<?php

namespace App\Controller;

use App\Entity\User;
use App\Repository\UserRepository;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Log\LoggerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Validator\Validator\ValidatorInterface;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Serializer\SerializerInterface;

class UserController extends AbstractController
{
    private $serializer;
    private $entityManager;
    private $validator;
    private $passwordHasher;
    private $logger;

    public function __construct(
        SerializerInterface $serializer,
        EntityManagerInterface $entityManager,
        ValidatorInterface $validator,
        UserPasswordHasherInterface $passwordHasher,
        LoggerInterface $logger
    ) {
        $this->serializer = $serializer;
        $this->entityManager = $entityManager;
        $this->validator = $validator;
        $this->passwordHasher = $passwordHasher;
        $this->logger = $logger;
    }

    public function getUsers(UserRepository $userRepository): Response
    {
        $users = $userRepository->findAll();
        $jsonContent = $this->serializer->serialize($users, 'json', ['groups' => 'list']);
        return new Response($jsonContent, Response::HTTP_OK, ['Content-Type' => 'application/json']);
    }


    public function getUserById(int $id, UserRepository $userRepository): Response
    {
        $user = $userRepository->find($id);

        if (!$user) {
            return $this->json(['error' => 'User not found'], Response::HTTP_NOT_FOUND);
        }

        // Chargez explicitement les activités
        $activities = $user->getActivities()->toArray();

        $userData = [
            'id' => $user->getId(),
            'email' => $user->getEmail(),
            'name' => $user->getName(),
            'activities' => array_map(function ($activity) {
                return [
                    'id' => $activity->getId(),
                    'title' => $activity->getTitle(),
                    // Ajoutez d'autres champs d'activité si nécessaire
                ];
            }, $activities)
        ];

        return $this->json($userData, Response::HTTP_OK);
    }

    public function postUser(Request $request, UserRepository $userRepository): Response
    {
        $data = json_decode($request->getContent(), true);

        // Check if the email already exists
        $existingUser = $userRepository->findOneBy(['email' => $data['email']]);
        if ($existingUser) {
            return $this->json(['error' => 'Email already exists'], Response::HTTP_CONFLICT);
        }

        $user = new User();
        $user->setName($data['name']);
        $user->setEmail($data['email']);
        $user->setRoles($data['roles']);

        // Hash the password before setting it
        $hashedPassword = $this->passwordHasher->hashPassword($user, $data['password']);
        $user->setPassword($hashedPassword);

        $errors = $this->validator->validate($user);
        if (count($errors) > 0) {
            return $this->json($errors, Response::HTTP_BAD_REQUEST);
        }

        $this->entityManager->persist($user);
        $this->entityManager->flush();

        return $this->json(['message' => 'User created successfully', 'user' => $user], Response::HTTP_CREATED, [], ['groups' => 'detail']);
    }

    public function putUser(Request $request, int $id, UserRepository $userRepository): Response
{
    $user = $userRepository->find($id);
    if (!$user) {
        return $this->json(['error' => 'User not found'], Response::HTTP_NOT_FOUND);
    }

    $data = json_decode($request->getContent(), true);

    // Vérifiez que toutes les clés nécessaires existent
    if (!isset($data['name']) || !isset($data['email']) || !isset($data['roles']) || !isset($data['password'])) {
        return $this->json(['error' => 'Missing required fields'], Response::HTTP_BAD_REQUEST);
    }

    // Vérification de l'email existant
    $existingUser = $this->entityManager->getRepository(User::class)->findOneBy(['email' => $data['email']]);
    if ($existingUser && $existingUser->getId() !== $user->getId()) {
        return $this->json(['error' => 'Email already exists'], Response::HTTP_CONFLICT);
    }

    $user->setName($data['name']);
    $user->setEmail($data['email']);
    $user->setRoles($data['roles']);
    $hashedPassword = $this->passwordHasher->hashPassword($user, $data['password']);
    $user->setPassword($hashedPassword);

    $errors = $this->validator->validate($user);
    if (count($errors) > 0) {
        return $this->json($errors, Response::HTTP_BAD_REQUEST);
    }

    $this->entityManager->flush();

    // Créez manuellement un tableau avec les données de l'utilisateur
    $userData = [
        'id' => $user->getId(),
        'name' => $user->getName(),
        'email' => $user->getEmail(),
        'roles' => $user->getRoles(),
    ];

    return $this->json([
        'message' => 'User updated successfully',
        'user' => $userData
    ], Response::HTTP_OK);
}
    public function deleteUser(User $user): Response
    {
        $this->entityManager->remove($user);
        $this->entityManager->flush();

        return $this->json(['message' => 'User deleted successfully'], Response::HTTP_OK);
    }
}
