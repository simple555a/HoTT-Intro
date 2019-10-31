Require Export section_03_nat.

(* Section 4. More inductive types *)

(** Analogous to the type of natural numbers, many types can be specified as
    inductive types. In this lecture we introduce some further examples of 
    inductive types: the unit type, the empty type, the booleans, coproducts,
    dependent pair types, and cartesian products. We also introduce the type of
    integers. *)

(** Section 4.2. The unit type *)

(** The unit type is an inductive type generated by a single point called star.
    *)

Inductive unit : Type :=
| star : unit.

(** Section 4.3. The empty type *)

(** The empty type is an inductive type with no constructors at all. *)

Inductive empty : Type := .

(** The induction principle gives a section of every family of types over the
    empty type. In other words, anything follows from falso: ex falso 
    quodlibet. *)

Definition ex_falso {B : empty -> Type} : forall x, B x.
Proof.
  intro x.
  induction x.
Defined.

Definition ex_falso_map {A} : empty -> A := ex_falso.

(** We use the empty type to define the negation of an arbitrary type. *)

Definition neg (A : Type) : Type := A -> empty.

(** Section 4.4. The booleans *)

(** The type of booleans is an inductive type generated by two constructors:
    true and false. *)

Inductive bool : Type :=
| true : bool
| false : bool.

(** Using the induction principle of the booleans, we can define some of the
    boolean operations. We show here how to define negation, conjunction, and
    disjunction as boolean operators. Some other boolean operators are defined
    in the exercises. *)

Definition negb (b : bool) : bool.
Proof.
  induction b.
  - exact false.
  - exact true.
Defined.

Definition andb (b b' : bool) : bool.
Proof.
  induction b.
  - induction b'.
    * exact true.
    * exact false.
  - induction b'.
    * exact false.
    * exact false.
Defined.

Definition orb (b b' : bool) : bool.
Proof.
  induction b.
  - induction b'.
    * exact true.
    * exact true.
  - induction b'.
    * exact true.
    * exact false.
Defined.

(** Section 4.5. Coproducts and the type of integers *)

(** The coproduct of two types is defined as an inductive type with 
    constructors

    inl : A -> coprod A B
    inr : B -> coprod A B. *)

Inductive coprod (A B : Type) : Type :=
| inl : A -> coprod A B
| inr : B -> coprod A B.

(** We make the arguments A and B of inl and inr implicit. *)

Arguments inl {A B}.
Arguments inr {A B}.

(** Using coproducts, the type of natural numbers, and the unit type we now
    construct the type of integers. *)

Definition Z : Type := coprod N (coprod unit N).

(** We define some integers close to zero. *)

Definition zero_Z : Z := inr (inl star).

Definition one_Z : Z := inr (inr zero_N).

Definition two_Z : Z := inr (inr one_N).

Definition neg_one_Z : Z := inl zero_N.

Definition neg_two_Z : Z := inl one_N.

(** Now we extend the successor function on the natural numbers to a successor
    function on the integers. *)

Definition succ_Z (k : Z) : Z.
Proof.
  destruct k as [n | x].
  - destruct n.
    * exact zero_Z.
    * exact (inl n).
  - destruct x as [x | n].
    * exact one_Z.
    * exact (inr (inr (succ_N n))).
Defined.

(** Section 4.6. Dependent pair types *)

(** Given a family B of types over A, we can for the type of pairs (x,y), 
    consisting of a term x:A and a term y:B(x). Note that the type of the term 
    y depends on the term x, hence we call such pairs dependent pairs.

    More traditionally, the type of dependent pair types is called the
    Sigma-type. It is defined as an inductive type, of which the pairs are the
    constructors. *)

Inductive Sigma (A : Type) (B : A -> Type) : Type :=
| pair : forall x, B x -> Sigma A B.

(** We make the arguments A and B of pair implicit. *)

Arguments pair {A B}.

(** Using the induction principle, we define the two projection functions on
    a dependent pair type. *)

Definition pr1 {A : Type} {B : A -> Type} (x : Sigma A B) : A.
Proof.
  induction x.
  assumption.
Defined.

Definition pr2 {A : Type} {B : A -> Type} (x : Sigma A B) : B (pr1 x).
Proof.
  induction x.
  assumption.
Defined.

(** Section 4.8. Cartesian products *)

(** The cartesian product of two types is defined as a special case of the
    dependent pair type. *)

Definition prod (A B : Type) : Type := Sigma A (fun x => B).

(** Exercises for section 4 *)

(** Exercise 4.2 *)

(** Exercise 4.2.a *)

Lemma double_neg_elim_decidable (A : Type) :
  coprod A (neg A) -> (neg (neg A) -> A).
Proof.
  intro x.
  induction x.
  - now apply const.
  - intro y. now apply ex_falso_map.
Defined.

(** Exercise 4.2.b *)

Lemma triple_neg_elim (A : Type) :
  neg (neg (neg A)) -> neg A.
Proof.
  intros f a.
  apply ex_falso_map.
  now apply f.
Defined.

(** Exercise 4.3 *)

Definition xorb (b b' : bool) : bool.
Proof.
  induction b.
  - induction b'.
    * exact false.
    * exact true.
  - induction b'.
    * exact true.
    * exact false.
Defined.

Definition impliesb (b b' : bool) : bool.
Proof.
  induction b.
  - induction b'.
    * exact true.
    * exact false.
  - induction b'.
    * exact true.
    * exact true.
Defined.

Definition iffb (b b' : bool) : bool.
Proof.
  induction b.
  - induction b'.
    * exact true.
    * exact false.
  - induction b'.
    * exact false.
    * exact true.
Defined.

Definition peirce_arrow (b b' : bool) : bool.
Proof.
  induction b.
  - induction b'.
    * exact false.
    * exact false.
  - induction b'.
    * exact false.
    * exact true.
Defined.

Definition sheffer_stroke (b b' : bool) : bool.
Proof.
  induction b.
  - induction b'.
    * exact false.
    * exact true.
  - induction b'.
    * exact true.
    * exact true.
Defined.

(** Exercise 4.4 *)

Definition pred_Z (k : Z) : Z.
Proof.
  destruct k as [n | x].
  - exact (inl (succ_N n)).
  - destruct x as [x | n].
    * exact neg_one_Z.
    * destruct n.
      ** exact zero_Z.
      ** exact (inr (inr n)).
Defined.

(** Exercise 4.5 *)

Definition add_Z (k l : Z) : Z.
Proof.
  destruct l as [n | x].
  - induction n as [|n s].
    * exact (pred_Z k).
    * exact (pred_Z s).
  - destruct x as [x | n].
    * exact k.
    * induction n as [|n s].
      ** exact (succ_Z k).
      ** exact (succ_Z s).
Defined.

Definition neg_Z (k : Z) : Z.
Proof.
  destruct k as [n | x].
  - exact (inr (inr n)).
  - destruct x as [x | n].
    * exact (inr (inl x)).
    * exact (inl n).
Defined.

Definition mul_Z (k l : Z) : Z.
Proof.
  destruct l as [n | x].
  - induction n as [|n m].
    * exact (neg_Z k).
    * exact (add_Z m (neg_Z k)).
  - destruct x as [x | n].
    * exact zero_Z.
    * induction n as [|n m].
      ** exact k.
      ** exact (add_Z m k).
Defined.

(** Exercise 4.6 *)

(** The following is ill-formed. I don't know yet how to fix it.

Fixpoint Fibonacci_Z (k : Z) : Z :=
  match k with
  | inl n =>
    match n with
    | zero_N => one_Z
    | succ_N m =>
      match m with
      | zero_N => neg_one_Z
      | succ_N m' =>
        add_Z (Fibonacci_Z (inl m)) (neg_Z (Fibonacci_Z (inl m')))
      end
    end
  | inr x =>
    match x with
    | inl x => zero_Z
    | inr n => inr (inr (Fibonacci (succ_N n)))
    end
  end.
 *)

(*
Proof.
  destruct k as [n | x].
  - induction n as [|n f].
    * exact one_Z.
    * exact (neg_Z !!!
  - destruct x as [x | n].
    * exact zero_Z.
    * exact (inr (inr (Fibonacci (succ_N n)))).
Defined.
 *)

(** Exercise 4.7 *)

Definition true' : coprod unit unit := inl star.

Definition false' : coprod unit unit := inr star.

Definition ind_coprod_unit_unit {P : coprod unit unit -> Type} (p1 : P true') (p0 : P false') : forall x, P x.
Proof.
  intro x.
  destruct x as [x | x].
  destruct x. assumption.
  destruct x. assumption.
Defined.

(** Exercise 4.8 *)

(** Exercise 4.8.a *)

Inductive list (A : Type) : Type :=
| nil : list A
| cons : A -> list A -> list A.

Arguments nil {A}.
Arguments cons {A}.

Definition in_list {A} (a : A) : list A := cons a nil.

(** Exercise 4.8.b *)

Definition fold_list {A B} (b : B) (m : A -> B -> B) : list A -> B.
Proof.
  intro l.
  induction l as [|a l' b'].
  - exact b.
  - exact (m a b').
Defined.

(** Exercise 4.8.c *)

Definition length_list {A} : list A -> N.
Proof.
  apply fold_list.
  - exact zero_N.
  - exact (const succ_N).
Defined.

Definition sum_list_N : list N -> N.
Proof.
  apply fold_list.
  - exact zero_N.
  - exact add_N.
Defined.
  
Definition concat_list {A} : list A -> (list A -> list A).
Proof.
  apply (@fold_list A (list A -> list A)).
  - exact (fun l => l).
  - intro a. exact (comp (cons a)).
Defined.

Definition flatten_list {A} : list (list A) -> list A.
Proof.
  apply fold_list.
  - exact nil.
  - exact concat_list.
Defined.

Definition reverse_list {A} : list A -> list A.
Proof.
  intro l.
  induction l as [|a l r].
  - exact nil.
  - exact (concat_list r (in_list a)).
Defined.
