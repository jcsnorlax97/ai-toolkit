# Diagram Review Checklist

Run this before delivering any client-facing flow diagram.

## Client Safety

- [ ] No internal class names, method names, or interface names in node labels
- [ ] No HTTP status codes or error enum values visible
- [ ] No database schema names, column names, or query details
- [ ] No internal jargon that requires developer context to interpret
- [ ] No credentials, environment names, or infrastructure details

## Accuracy

- [ ] All decision branches are accounted for (Yes and No paths lead somewhere)
- [ ] Error outcomes are present where a real failure can occur
- [ ] Phase order matches the actual system flow
- [ ] System ownership (which swimlane each step is in) is correct

## Clarity

- [ ] No single diagram has more than ~8–10 nodes — split if needed
- [ ] Each node label is readable without prior technical context
- [ ] Step numbers, when used, are sequential and unambiguous
- [ ] Error paths are short and clearly labelled
- [ ] A visual legend is present when colours or icons carry meaning

## Formatting

- [ ] Visual conventions are consistent and improve comprehension
- [ ] Icons are used only when they help the intended audience orient quickly
- [ ] Document header table is present when the deliverable is formal
- [ ] Plain-language notes below each diagram
- [ ] Cross-reference to technical documentation included when useful
