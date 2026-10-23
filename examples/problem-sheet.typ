// A photocopied problem sheet, filed in a ring binder.
#import "../typst/lib.typ" as lookscanned

#set page(paper: "a4", margin: (x: 25mm, y: 22mm))
#set text(font: "New Computer Modern", size: 11pt)
#set par(justify: true)
#set enum(numbering: n => strong[#n.])

#show: lookscanned.scan.with(preset: "photocopy", seed: 9, intensity: 0.8, edges: (punch-holes: true))

#grid(
  columns: (1fr, auto),
  [*Linear Algebra II* \ Problem sheet 3],
  align(right)[Week 5 \ Due Monday],
)
#line(length: 100%, stroke: 0.6pt)

= Eigenvalues and diagonalisation

Throughout, $E$ is a finite-dimensional vector space over $RR$ and
$f in cal(L)(E)$. We write $chi_f (lambda) = det(f - lambda id_E)$.

+ Let $A = mat(2, 1; 1, 2)$. Find the eigenvalues of $A$, an orthonormal basis
  of eigenvectors, and an orthogonal matrix $P$ such that $P^top A P$ is diagonal.

+ Show that if $f$ is nilpotent, then $0$ is its only eigenvalue. Deduce that a
  nilpotent endomorphism is diagonalisable if and only if it is zero.

+ Let $f$ have $n = dim E$ distinct eigenvalues $lambda_1, dots, lambda_n$.
  Prove that $f$ is diagonalisable and that
  $
    det f = product_(i=1)^n lambda_i, quad tr f = sum_(i=1)^n lambda_i.
  $

+ _(Cayley–Hamilton.)_ Check that $chi_A (A) = 0$ for the matrix of question 1,
  then use it to express $A^(-1)$ as a polynomial in $A$.

+ Let $(u_n)$ be defined by $u_0 = 0$, $u_1 = 1$ and $u_(n+2) = u_(n+1) + u_n$.
  Writing $X_n = vec(u_(n+1), u_n)$, find $M$ such that $X_(n+1) = M X_n$, and
  deduce the closed form
  $
    u_n = 1 / sqrt(5) ((1 + sqrt(5)) / 2)^n - 1 / sqrt(5) ((1 - sqrt(5)) / 2)^n.
  $

#v(1fr)
#align(center, text(size: 9pt)[Questions 4 and 5 will be discussed in the tutorial.])

#lookscanned.stamp("Marked", color: rgb("#b03a2e"), size: 13pt, seed: 4, at: (x: 68%, y: 84%))
