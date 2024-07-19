<?php

namespace App\Controller;

use App\Entity\Rating;
use App\Repository\RatingRepository;
use App\Repository\ActivityRepository;
use App\Repository\UserRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Serializer\SerializerInterface;
use Symfony\Component\Validator\Validator\ValidatorInterface;
use Symfony\Component\Serializer\Normalizer\AbstractNormalizer;
use Doctrine\Persistence\Proxy;


#[Route('/api/ratings')]
class RatingController extends AbstractController
{
    private $serializer;
    private $entityManager;
    private $validator;

    public function __construct(
        SerializerInterface $serializer,
        EntityManagerInterface $entityManager,
        ValidatorInterface $validator
    ) {
        $this->serializer = $serializer;
        $this->entityManager = $entityManager;
        $this->validator = $validator;
    }


    #[Route('', methods: ['GET'])]
    public function getRatings(RatingRepository $ratingRepository): Response
    {
        $ratings = $ratingRepository->findAll();
        
        $context = [
            'groups' => 'list',
            AbstractNormalizer::CIRCULAR_REFERENCE_HANDLER => function ($object) {
                return $object->getId();
            },
            AbstractNormalizer::IGNORED_ATTRIBUTES => ['__initializer__', '__cloner__', '__isInitialized__'],
            AbstractNormalizer::CALLBACKS => [
                'userId' => function ($innerObject, $outerObject, string $attributeName, string $format = null, array $context = []) {
                    if (method_exists($innerObject, '__load')) {
                        $innerObject->__load();
                        return [
                            'id' => $innerObject->getId(),
                            'name' => $innerObject->getName(),
                        ];
                    }
                    return $innerObject;
                },
            ],
        ];
    
        $jsonContent = $this->serializer->serialize($ratings, 'json', $context);
        
        return new Response($jsonContent, Response::HTTP_OK, ['Content-Type' => 'application/json']);
    }

    #[Route('/{id}', methods: ['GET'])]
    public function getRatingById(int $id, RatingRepository $ratingRepository): Response
    {
        $rating = $ratingRepository->find($id);

        if (!$rating) {
            return $this->json(['error' => 'Rating not found'], Response::HTTP_NOT_FOUND);
        }

        $jsonContent = $this->serializer->serialize($rating, 'json', ['groups' => 'detail']);
        return new Response($jsonContent, Response::HTTP_OK, ['Content-Type' => 'application/json']);
    }

    #[Route('', methods: ['POST'])]
    public function postRating(Request $request, ActivityRepository $activityRepository, UserRepository $userRepository): Response
    {
        $data = json_decode($request->getContent(), true);

        $rating = new Rating();
        $rating->setNote($data['note']);
        $rating->setComments($data['comments']);
        $rating->setDate(new \DateTime());

        $activity = $activityRepository->find($data['activity_id']);
        $user = $userRepository->find($data['user_id']);

        if (!$activity || !$user) {
            return $this->json(['error' => 'Activity or User not found'], Response::HTTP_BAD_REQUEST);
        }

        $rating->setActivity($activity);
        $rating->setUserRating($user);

        $errors = $this->validator->validate($rating);
        if (count($errors) > 0) {
            return $this->json($errors, Response::HTTP_BAD_REQUEST);
        }

        $this->entityManager->persist($rating);
        $this->entityManager->flush();

        return $this->json([
            'message' => 'Rating created successfully',
            'rating' => [
                'id' => $rating->getId(),
                'note' => $rating->getNote(),
                'comments' => $rating->getComments(),
                'date' => $rating->getDate()->format('Y-m-d H:i:s'),
                'activity_id' => $rating->getActivity()->getId(),
                'user_id' => $rating->getUserRating()->getId()
            ]
        ], Response::HTTP_CREATED);
    }

    #[Route('/{id}', methods: ['PUT'])]
    public function putRating(Request $request, int $id, RatingRepository $ratingRepository): Response
    {
        $rating = $ratingRepository->find($id);
        if (!$rating) {
            return $this->json(['error' => 'Rating not found'], Response::HTTP_NOT_FOUND);
        }

        $data = json_decode($request->getContent(), true);

        if (isset($data['note'])) {
            $rating->setNote($data['note']);
        }
        if (isset($data['comments'])) {
            $rating->setComments($data['comments']);
        }

        $errors = $this->validator->validate($rating);
        if (count($errors) > 0) {
            return $this->json($errors, Response::HTTP_BAD_REQUEST);
        }

        $this->entityManager->flush();

        $jsonContent = $this->serializer->serialize($rating, 'json', ['groups' => 'detail']);
        return new Response($jsonContent, Response::HTTP_OK, ['Content-Type' => 'application/json']);
    }

    #[Route('/{id}', methods: ['DELETE'])]
    public function deleteRating(Rating $rating): Response
    {
        $this->entityManager->remove($rating);
        $this->entityManager->flush();

        return $this->json(['message' => 'Rating deleted successfully'], Response::HTTP_OK);
    }
}
