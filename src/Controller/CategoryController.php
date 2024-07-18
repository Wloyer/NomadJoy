<?php

namespace App\Controller;

use App\Entity\Category;
use App\Repository\CategoryRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Validator\Validator\ValidatorInterface;
use Symfony\Component\Serializer\SerializerInterface;

#[Route('/api')]
class CategoryController extends AbstractController
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

    #[Route('/categories', name: 'get_categories', methods: ['GET'])]
    public function getCategories(CategoryRepository $categoryRepository): Response
    {
        $categories = $categoryRepository->findAll();
        $data = $this->serializer->serialize($categories, 'json', ['groups' => 'list']);
        return new Response($data, Response::HTTP_OK, ['Content-Type' => 'application/json']);
    }

    #[Route('/categories/{id}', name: 'get_category_by_id', methods: ['GET'])]
    public function getCategoryById(Category $category): Response
    {
        $data = $this->serializer->serialize($category, 'json', ['groups' => 'detail']);
        return new Response($data, Response::HTTP_OK, ['Content-Type' => 'application/json']);
    }

    #[Route('/categories', name: 'post_category', methods: ['POST'])]
    public function postCategory(Request $request): Response
    {
        $data = json_decode($request->getContent(), true);

        if (!isset($data['name'])) {
            return $this->json(['error' => 'Missing name field'], Response::HTTP_BAD_REQUEST);
        }

        $category = new Category();
        $category->setName($data['name']);

        $errors = $this->validator->validate($category);
        if (count($errors) > 0) {
            $errorsString = (string) $errors;
            return $this->json(['error' => $errorsString], Response::HTTP_BAD_REQUEST);
        }

        $this->entityManager->persist($category);
        $this->entityManager->flush();

        $data = $this->serializer->serialize($category, 'json', ['groups' => 'detail']);
        return new Response($data, Response::HTTP_CREATED, ['Content-Type' => 'application/json']);
    }

    #[Route('/categories/{id}', name: 'put_category', methods: ['PUT'])]
    public function putCategory(Request $request, Category $category): Response
    {
        $data = json_decode($request->getContent(), true);

        if (!isset($data['name'])) {
            return $this->json(['error' => 'Missing name field'], Response::HTTP_BAD_REQUEST);
        }

        $category->setName($data['name']);

        $errors = $this->validator->validate($category);
        if (count($errors) > 0) {
            $errorsString = (string) $errors;
            return $this->json(['error' => $errorsString], Response::HTTP_BAD_REQUEST);
        }

        $this->entityManager->flush();

        $data = $this->serializer->serialize($category, 'json', ['groups' => 'detail']);
        return new Response($data, Response::HTTP_OK, ['Content-Type' => 'application/json']);
    }

    #[Route('/categories/{id}', name: 'delete_category', methods: ['DELETE'])]
    public function deleteCategory(Category $category): Response
    {
        $this->entityManager->remove($category);
        $this->entityManager->flush();

        return $this->json(['message' => 'Category deleted successfully'], Response::HTTP_OK);
    }
}