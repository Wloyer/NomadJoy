<?php

namespace App\Controller;

use App\Entity\Activity;
use App\Repository\ActivityRepository;
use App\Repository\CategoryRepository;
use App\Repository\UserRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Validator\Validator\ValidatorInterface;

/**
 * @Route("/api")
 */
class ActivityController extends AbstractController
{
    private $entityManager;
    private $validator;

    public function __construct(EntityManagerInterface $entityManager, ValidatorInterface $validator)
    {
        $this->entityManager = $entityManager;
        $this->validator = $validator;
    }

    /**
     * @Route("/activities", name="get_activities", methods={"GET"})
     */
    public function getActivities(ActivityRepository $activityRepository): Response
    {
        $activities = $activityRepository->findAll();
        return $this->json($activities, Response::HTTP_OK, [], ['groups' => 'list']);
    }

    /**
     * @Route("/activities/{id}", name="get_activity_by_id", methods={"GET"})
     */
    public function getActivityById(Activity $activity): Response
    {
        return $this->json($activity, Response::HTTP_OK, [], ['groups' => 'detail']);
    }

    /**
     * @Route("/activities", name="post_activity", methods={"POST"})
     */
    public function postActivity(Request $request, UserRepository $userRepository, CategoryRepository $categoryRepository): Response
    {
        $data = json_decode($request->getContent(), true);

        $user = $userRepository->find($data['user_id']);
        $category = $categoryRepository->find($data['category_id']);

        if (!$user || !$category) {
            return $this->json(['error' => 'Invalid user or category'], Response::HTTP_BAD_REQUEST);
        }

        $activity = new Activity();
        $activity->setTitle($data['title']);
        $activity->setDescription($data['description']);
        $activity->setDatePublication(new \DateTime($data['datePublication']));
        $activity->setAuthor($data['author']);
        $activity->setType($data['type']);
        $activity->setUserID($user);
        $activity->setCategory($category);

        $errors = $this->validator->validate($activity);
        if (count($errors) > 0) {
            return $this->json($errors, Response::HTTP_BAD_REQUEST);
        }

        $this->entityManager->persist($activity);
        $this->entityManager->flush();

        return $this->json($activity, Response::HTTP_CREATED, [], ['groups' => 'detail']);
    }

    /**
     * @Route("/activities/{id}", name="put_activity", methods={"PUT"})
     */
    public function putActivity(Request $request, Activity $activity): Response
    {
        $data = json_decode($request->getContent(), true);

        $activity->setTitle($data['title']);
        $activity->setDescription($data['description']);
        $activity->setDatePublication(new \DateTime($data['datePublication']));
        $activity->setAuthor($data['author']);
        $activity->setType($data['type']);
        // Vous pouvez récupérer et définir les relations avec Category et User ici

        $errors = $this->validator->validate($activity);
        if (count($errors) > 0) {
            return $this->json($errors, Response::HTTP_BAD_REQUEST);
        }

        $this->entityManager->flush();

        return $this->json($activity, Response::HTTP_OK, [], ['groups' => 'detail']);
    }

    /**
     * @Route("/activities/{id}", name="delete_activity", methods={"DELETE"})
     */
    public function deleteActivity(Activity $activity): Response
    {
        $this->entityManager->remove($activity);
        $this->entityManager->flush();

        return $this->json(null, Response::HTTP_NO_CONTENT);
    }
}