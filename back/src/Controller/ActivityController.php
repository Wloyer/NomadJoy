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
use Symfony\Component\Serializer\SerializerInterface;

#[Route('/api')]
class ActivityController extends AbstractController
{
    private $entityManager;
    private $validator;
    private $serializer;

    public function __construct(
        EntityManagerInterface $entityManager,
        ValidatorInterface $validator,
        SerializerInterface $serializer
    ) {
        $this->entityManager = $entityManager;
        $this->validator = $validator;
        $this->serializer = $serializer;
    }

    #[Route('/activities', name: 'get_activities', methods: ['GET'])]
    public function getActivities(ActivityRepository $activityRepository): Response
    {
        $activities = $activityRepository->findAll();
        $data = [];

        foreach ($activities as $activity) {
            $ratings = array_map(function ($rating) {
                return $rating->getNote();
            }, $activity->getRatings()->toArray());

            $data[] = [
                'id' => $activity->getId(),
                'category_id' => $activity->getCategory()->getId(),
                'user_id' => $activity->getUserID()->getId(),
                'title' => $activity->getTitle(),
                'description' => $activity->getDescription(),
                'date_publication' => $activity->getDatePublication()->format('Y-m-d'),
                'author' => $activity->getAuthor(),
                'type' => $activity->getType(),
                'ratings' => $ratings,
            ];
        }

        return $this->json($data);
    }


    #[Route('/activities/{id}', name: 'get_activity_by_id', methods: ['GET'])]
    public function getActivityById(int $id, ActivityRepository $activityRepository): Response
    {
        $activity = $activityRepository->find($id);

        if (!$activity) {
            return $this->json(['error' => 'Activity not found'], Response::HTTP_NOT_FOUND);
        }

        $data = $this->serializer->serialize($activity, 'json', ['groups' => 'detail']);
        return new Response($data, Response::HTTP_OK, ['Content-Type' => 'application/json']);
    }

    #[Route('/activities', name: 'post_activity', methods: ['POST'])]
    public function postActivity(Request $request, UserRepository $userRepository, CategoryRepository $categoryRepository): Response
    {
        $data = json_decode($request->getContent(), true);

        if (!$this->validateActivityData($data)) {
            return $this->json(['error' => 'Missing required fields'], Response::HTTP_BAD_REQUEST);
        }

        $user = $userRepository->find($data['user_id']);
        $category = $categoryRepository->find($data['category_id']);

        if (!$user || !$category) {
            return $this->json(['error' => 'Invalid user or category'], Response::HTTP_BAD_REQUEST);
        }

        $activity = new Activity();
        $this->setActivityData($activity, $data, $user, $category);

        $errors = $this->validator->validate($activity);
        if (count($errors) > 0) {
            $errorsString = (string) $errors;
            return $this->json(['error' => $errorsString], Response::HTTP_BAD_REQUEST);
        }

        $this->entityManager->persist($activity);
        $this->entityManager->flush();

        $data = $this->serializer->serialize($activity, 'json', ['groups' => 'detail']);
        return new Response($data, Response::HTTP_CREATED, ['Content-Type' => 'application/json']);
    }

    #[Route('/activities/{id}', name: 'put_activity', methods: ['PUT'])]
    public function putActivity(Request $request, Activity $activity, UserRepository $userRepository, CategoryRepository $categoryRepository): Response
    {
        $data = json_decode($request->getContent(), true);

        if (!$this->validateActivityData($data)) {
            return $this->json(['error' => 'Missing required fields'], Response::HTTP_BAD_REQUEST);
        }

        $user = $userRepository->find($data['user_id']);
        $category = $categoryRepository->find($data['category_id']);

        if (!$user || !$category) {
            return $this->json(['error' => 'Invalid user or category'], Response::HTTP_BAD_REQUEST);
        }

        $this->setActivityData($activity, $data, $user, $category);

        $errors = $this->validator->validate($activity);
        if (count($errors) > 0) {
            $errorsString = (string) $errors;
            return $this->json(['error' => $errorsString], Response::HTTP_BAD_REQUEST);
        }

        $this->entityManager->flush();

        $data = $this->serializer->serialize($activity, 'json', ['groups' => 'detail']);
        return new Response($data, Response::HTTP_OK, ['Content-Type' => 'application/json']);
    }

    #[Route('/activities/{id}', name: 'delete_activity', methods: ['DELETE'])]
    public function deleteActivity(Activity $activity): Response
    {
        $this->entityManager->remove($activity);
        $this->entityManager->flush();

        return $this->json(['message' => 'Activity deleted successfully'], Response::HTTP_OK);
    }

    private function validateActivityData(array $data): bool
    {
        $requiredFields = ['title', 'description', 'datePublication', 'author', 'type', 'user_id', 'category_id'];
        foreach ($requiredFields as $field) {
            if (!isset($data[$field])) {
                return false;
            }
        }
        return true;
    }

    private function setActivityData(Activity $activity, array $data, $user, $category): void
    {
        $activity->setTitle($data['title']);
        $activity->setDescription($data['description']);
        $activity->setDatePublication(new \DateTime($data['datePublication']));
        $activity->setAuthor($data['author']);
        $activity->setType($data['type']);
        $activity->setUserID($user);
        $activity->setCategory($category);
    }
}
