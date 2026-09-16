# Style and evidence

## TL;DR

Write like a senior engineer explaining the system to a junior colleague who will maintain it later. Be technical, specific, and readable. Remove agent voice, filler, and false certainty.

## Paragraphs and headings

Use paragraphs of two to five sentences, usually under 120 words. Add a meaningful heading before the reader has to hold several ideas in working memory. Prefer no more than three heading levels.

Use bullets for true lists, comparisons, steps, or file maps. Do not turn the entire document into bullets. Avoid large tables that become unreadable in narrow editors.

Every file needs a local TL;DR, but do not repeat the same project summary verbatim in every chapter.

## Human-facing voice

Use the tense that matches reality:

- completed work: “The handler now validates…”;
- current behavior: “The service owns…”;
- planned work: “The next wave will add…”.

Avoid agent-facing phrases such as “the agent should,” “execute the following,” “we need to inspect,” or “next, modify the file.” Describe the system and the reasoning, not the agent's private workflow.

Do not use em dashes. Avoid generic AI phrases such as “in today's landscape,” “it is important to note,” “robust,” “seamless,” or “comprehensive” unless the word carries precise technical meaning.

## Technical depth

Define unfamiliar jargon at first use. Explain why a responsibility belongs in its layer, how the data flows, and what fails at boundaries. Prefer a concrete example from this codebase over a generic textbook paragraph.

Use short code excerpts only when the syntax itself matters. Keep excerpts under 20 lines when possible; otherwise reference the source symbol.

## Evidence labels

Use explicit labels when certainty matters:

- **Observed:** directly supported by code, output, logs, or reproduced behavior.
- **Assumption:** unverified premise used for design or explanation.
- **Hypothesis:** testable explanation for behavior.
- **Proposed:** intended future state.
- **Verified:** exercised by a named check with a recorded result.
- **Unverified:** plausible but not exercised.

Do not invent intent. If code does not reveal why a decision was made, describe what it does and state that the original rationale is unknown.

## No fluff test

Delete a sentence if removing it loses no fact, causal link, decision, limitation, navigation aid, or debugging value.
