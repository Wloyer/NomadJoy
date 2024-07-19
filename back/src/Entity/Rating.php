<?php

namespace App\Entity;

use App\Repository\RatingRepository;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Serializer\Annotation\Groups;

#[ORM\Entity(repositoryClass: RatingRepository::class)]
class Rating
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    #[Groups(['list', 'detail'])]
    private ?int $id = null;

    #[ORM\Column]
    #[Groups(['list', 'detail'])]
    private ?int $note = null;

    #[ORM\Column(type: "text", nullable: true)]
    #[Groups(['list', 'detail'])]
    private ?string $comments = null;

    #[ORM\Column(type: "datetime")]
    #[Groups(['list', 'detail'])]
    private ?\DateTimeInterface $date = null;

    #[ORM\ManyToOne(targetEntity: Activity::class, inversedBy: 'ratings')]
    #[ORM\JoinColumn(nullable: false)]
    #[Groups(['list', 'detail'])]
    private ?Activity $activity = null;

    #[ORM\ManyToOne(targetEntity: User::class)]
    #[ORM\JoinColumn(nullable: false)]
    #[Groups(['list', 'detail'])]
    private ?User $userRating = null;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getNote(): ?int
    {
        return $this->note;
    }

    public function setNote(int $note): self
    {
        $this->note = $note;

        return $this;
    }

    public function getComments(): ?string
    {
        return $this->comments;
    }

    public function setComments(?string $comments): self
    {
        $this->comments = $comments;

        return $this;
    }

    public function getDate(): ?\DateTimeInterface
    {
        return $this->date;
    }

    public function setDate(\DateTimeInterface $date): self
    {
        $this->date = $date;

        return $this;
    }

    public function getActivity(): ?Activity
    {
        return $this->activity;
    }

    public function setActivity(?Activity $activity): self
    {
        $this->activity = $activity;

        return $this;
    }

    public function getUserRating(): ?User
    {
        return $this->userRating;
    }

    public function setUserRating(?User $userRating): self
    {
        $this->userRating = $userRating;

        return $this;
    }
}
