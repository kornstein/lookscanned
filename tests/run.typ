// Renders `--input case=<name>`, or lists the cases for `typst query`.
#import "cases.typ": cases

#let case = sys.inputs.at("case", default: none)
#if case == none [
  #metadata(cases.keys()) <cases>
] else {
  assert(case in cases, message: "unknown case " + repr(case) + ", expected one of " + cases.keys().join(", "))
  (cases.at(case))()
}
