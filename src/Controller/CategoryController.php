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

/**
 * @Route("/api")
 */
class CategoryController extends AbstractController
{
    private $entityManager;
    private $validator;

    public function __construct(EntityManagerInterface $entityManager, ValidatorInterface $validator)
    {
        $this->entityManager = $entityManager;
        $this->validator = $validator;
    }

    /**
     * @Route("/categories", name="get_categories", methods={"GET"})
     */
    public function getCategories(CategoryRepository $categoryRepository): Response
    {
        $categories = $categoryRepository->findAll();
        return $this->json($categories, Response::HTTP_OK, [], ['groups' => 'list']);
    }

    /**
     * @Route("/categories/{id}", name="get_category_by_id", methods={"GET"})
     */
    public function getCategoryById(Category $category): Response
    {
        return $this->json($category, Response::HTTP_OK, [], ['groups' => 'detail']);
    }

    /**
     * @Route("/categories", name="post_category", methods={"POST"})
     */
    public function postCategory(Request $request): Response
    {
        $data = json_decode($request->getContent(), true);

        $category = new Category();
        $category->setName($data['name']);

        $errors = $this->validator->validate($category);
        if (count($errors) > 0) {
            return $this->json($errors, Response::HTTP_BAD_REQUEST);
        }

        $this->entityManager->persist($category);
        $this->entityManager->flush();

        return $this->json($category, Response::HTTP_CREATED, [], ['groups' => 'detail']);
    }

    /**
     * @Route("/categories/{id}", name="put_category", methods={"PUT"})
     */
    public function putCategory(Request $request, Category $category): Response
    {
        $data = json_decode($request->getContent(), true);

        $category->setName($data['name']);

        $errors = $this->validator->validate($category);
        if (count($errors) > 0) {
            return $this->json($errors, Response::HTTP_BAD_REQUEST);
        }

        $this->entityManager->flush();

        return $this->json($category, Response::HTTP_OK, [], ['groups' => 'detail']);
    }

    /**
     * @Route("/categories/{id}", name="delete_category", methods={"DELETE"})
     */
    public function deleteCategory(Category $category): Response
    {
        $this->entityManager->remove($category);
        $this->entityManager->flush();

        return $this->json(null, Response::HTTP_NO_CONTENT);
    }
}