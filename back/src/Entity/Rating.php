<?php

namespace App\Entity;

use App\Repository\RatingRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use JMS\Serializer\Annotation as Serializer;

#[ORM\Entity(repositoryClass: RatingRepository::class)]
class Rating
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    #[Serializer\Groups(['list', 'detail'])]
    private ?int $id = null;

    #[ORM\Column]
    #[Serializer\Groups(['list', 'detail'])]
    private ?float $note = null;

    #[ORM\Column(length: 255)]
    #[Serializer\Groups(['list', 'detail'])]
    private ?string $comments = null;

    #[ORM\Column(type: Types::DATETIME_MUTABLE)]
    #[Serializer\Groups(['list', 'detail'])]
    private ?\DateTimeInterface $date = null;

    #[ORM\ManyToOne(inversedBy: 'ratings')]
    #[Serializer\Groups(['list', 'detail'])]
    private ?activity $Activity = null;

    #[ORM\ManyToOne(inversedBy: 'ratings')]
    #[Serializer\Groups(['list', 'detail'])]
    private ?user $UserRating = null;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getNote(): ?float
    {
        return $this->note;
    }

    public function setNote(float $note): static
    {
        $this->note = $note;

        return $this;
    }

    public function getComments(): ?string
    {
        return $this->comments;
    }

    public function setComments(string $comments): static
    {
        $this->comments = $comments;

        return $this;
    }

    public function getDate(): ?\DateTimeInterface
    {
        return $this->date;
    }

    public function setDate(\DateTimeInterface $date): static
    {
        $this->date = $date;

        return $this;
    }

    public function getActivity(): ?activity
    {
        return $this->Activity;
    }

    public function setActivity(?activity $Activity): static
    {
        $this->Activity = $Activity;

        return $this;
    }

    public function getUserRating(): ?user
    {
        return $this->UserRating;
    }

    public function setUserRating(?user $UserRating): static
    {
        $this->UserRating = $UserRating;

        return $this;
    }
}
