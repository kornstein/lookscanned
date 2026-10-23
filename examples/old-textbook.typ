// A mid-century analysis textbook: mousse-notes for the typesetting,
// lookscanned for the decades on a library shelf.
#import "../typst/lib.typ" as lookscanned
#import "@preview/mousse-notes:2.0.1": *

#set document(title: [Elements of Analysis], author: "A. N. Example")
#set page(width: 139.7mm, height: 215.9mm)

#show: lookscanned.scan.with(
  preset: "old-paper",
  seed: 12,
  edges: (binding: true),
  skew: (page-rotation: 0.6deg),
)
// mousse-notes requires `style` to be the last show rule.
#show: style

#title-page(
  subtitle: upper[Volume I: Sequences and Series],
  primary: upper[A course of lectures \ delivered at the Faculty of Science],
  secondary: upper[Second edition, revised \ 1958],
)

= Sequences of Real Numbers

#epigraph(attribution: [after Cauchy])[
  A quantity which approaches a fixed value indefinitely, so as to differ from
  it by as little as one wishes, is said to have that value for its limit.
]

== Convergence

Throughout this chapter, $(u_n)_(n in NN)$ denotes a sequence of real numbers.
We make precise the intuitive idea that the terms $u_n$ eventually remain as
close as we please to some fixed number.

#definition[
  The sequence $(u_n)$ _converges_ to $ell in RR$ if
  $
    forall epsilon > 0, quad exists N in NN, quad forall n >= N, quad abs(u_n - ell) <= epsilon.
  $
  We then write $u_n -> ell$, or $lim_(n -> infinity) u_n = ell$.
]

#proposition[The limit of a convergent sequence is unique.] <prop_unique>
#proof[
  Suppose $u_n -> ell$ and $u_n -> ell'$, and let $epsilon > 0$. For all $n$
  large enough, both $abs(u_n - ell) <= epsilon$ and $abs(u_n - ell') <= epsilon$
  hold, hence $abs(ell - ell') <= 2 epsilon$ by the triangle inequality. Since
  $epsilon$ is arbitrary, $ell = ell'$. $qed$
]

#align(right, lookscanned.scribble(body: "see also Ex. 1", color: rgb("#2a3f8f"), angle: -4deg))

== Cauchy Sequences

The definition of convergence requires the limit to be known in advance. The
following notion depends on the terms of the sequence alone.

#definition[
  The sequence $(u_n)$ is a _Cauchy sequence_ if
  $
    forall epsilon > 0, quad exists N in NN, quad forall p, q >= N, quad abs(u_p - u_q) <= epsilon.
  $
]

#theorem(name: "Cauchy criterion")[
  A sequence of real numbers converges if and only if it is a Cauchy sequence.
] <thm_cauchy>
#proof[
  If $u_n -> ell$, then $abs(u_p - u_q) <= abs(u_p - ell) + abs(ell - u_q)$,
  and both terms are small for $p, q$ large. Conversely, a Cauchy sequence is
  bounded, so by the Bolzano–Weierstrass theorem it has a subsequence
  $u_(phi(n)) -> ell$. For $n$ and $phi(n)$ both at least $N$,
  $
    abs(u_n - ell) <= abs(u_n - u_(phi(n))) + abs(u_(phi(n)) - ell) <= 2 epsilon,
  $
  so the whole sequence converges to $ell$. $qed$
]

#remark[
  @thm_cauchy fails in $QQ$: the decimal approximations of $sqrt(2)$ form a
  Cauchy sequence of rationals with no rational limit. Completeness is
  precisely the property that distinguishes $RR$ from $QQ$.
]

== Series

#definition[
  The series $sum u_n$ _converges_ if the sequence of partial sums
  $S_N = sum_(n=0)^N u_n$ converges. Its limit is written $sum_(n=0)^infinity u_n$.
]

#example(name: "Geometric series")[
  For $abs(q) < 1$, $S_N = (1 - q^(N+1)) / (1 - q)$, hence
  $
    sum_(n=0)^infinity q^n = 1 / (1 - q).
  $ <eq_geometric>
]

#example(name: "Harmonic series")[
  Grouping the terms of $sum 1/n$ between consecutive powers of two gives
  $
    sum_(n = 2^k + 1)^(2^(k+1)) 1 / n >= 2^k dot 1 / 2^(k+1) = 1 / 2,
  $
  so the partial sums are unbounded and the series diverges, although its
  terms tend to $0$.
]

#lookscanned.stain(at: (x: 78%, y: 88%), size: 34mm, seed: 2)

== Exercises

+ Show that a convergent sequence is bounded. Is the converse true?
+ Let $u_n = sum_(k=1)^n 1 / k^2$. Prove that $(u_n)$ is a Cauchy sequence.
+ Using @eq_geometric, compute $sum_(n=1)^infinity n q^(n-1)$ for $abs(q) < 1$.
+ Give an example of a bounded sequence that is not a Cauchy sequence.

#lookscanned.scribble(width: 3cm, seed: 5, color: rgb("#2a3f8f"), angle: 6deg)
