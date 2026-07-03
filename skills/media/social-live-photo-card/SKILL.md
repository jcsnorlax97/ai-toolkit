---
name: social-live-photo-card
description: Turn user-provided short video material into a social-platform Live Photo card when one small motion point explains more than a static image, with first-frame, duration, crop, and publish-path checks.
status: trial
problem: Agents often treat Live Photo work as generic video export, missing the static first-frame requirement, short platform duration limits, card layout constraints, and phone-side publishing path.
when-not-to-use: Do not use for long-form video editing, pure photo retouching, unauthorized public-media harvesting, full tutorials that need sequential explanation, or static social cards with no motion evidence.
maintainer: Justin Choi
---

# Social Live Photo Card

Create a social card that behaves like a still image first and a short motion
asset second. The output should still read as a publishable card when the motion
does not play.

Use this skill when the user has video material for a social post and asks for a
Live Photo, dynamic card, animated social card, Rednote/Xiaohongshu Live Photo,
or WeChat article Live Photo.

## Inputs

- User-provided video clips, screen recordings, product captures, or short
  lifestyle clips.
- Optional text, article excerpt, product claim, tutorial step, or target
  platform.
- Optional existing static card style, brand constraints, or visual examples.

Default to user-provided media. Use public media only for explicitly approved
demo or test work, and keep source attribution.

## Output

Write all generated artifacts into the task output folder, not into the skill
directory:

- static first-frame JPG or PNG
- preview video for review
- MOV or platform-required motion asset when tooling is available
- `.pvt` package only when a local packager exists and is verified
- short delivery note explaining platform duration, publish path, and any
  remaining manual phone-side step

## Workflow

### 1. Confirm Platform And Motion Point

Identify the target:

- Rednote/Xiaohongshu: design around a `5s` Live Photo.
- WeChat article: design around a `3s` Live Photo.
- Local test or unknown platform: ask or choose the stricter `3s` default.

Name the single motion point the viewer should understand without audio. If the
clip needs a full tutorial, narration, or a long sequence, recommend static
multi-card instructions or video instead of Live Photo.

### 2. Screen The Material

Prefer clips near 10 seconds or less. If the source is longer or unclear, create
a sparse contact sheet of 8-15 frames before editing. Use it to check for:

- black or empty first frames
- transitions crossing pages or scenes
- UI text too small for mobile
- key result not yet visible
- subject, face, product, button, or result area getting cropped

Ask the user to choose a time range when the contact sheet does not make the
best segment obvious.

### 3. Choose The Card Structure

Pick one structure:

- Single video card: one strong clip, optionally with one short title group.
- Two-, three-, or four-panel collage: multiple attractive clips where the
  visuals carry the message and text can stay minimal.
- Triple Live Photo: three parallel results, states, views, or examples. Do not
  use this for a sequence that must be understood in order.
- No Live Photo: motion is decorative, confusing, too long, or less clear than a
  static card.

### 4. Make The First Frame Work As A Static Card

Before generating motion assets, render or inspect the first frame as a normal
card:

- target the platform aspect ratio, usually `3:4`
- keep the subject and result visible
- avoid covering faces, products, buttons, or result areas with text
- use one concise title group only when it improves comprehension
- preserve a quiet zone for text instead of defaulting to full-image overlays
- do not put production notes, keyboard shortcuts, or instructions on the card

If the first frame fails, fix crop, segment, or layout before continuing.

### 5. Generate And Package Motion Assets

Generate the shortest asset that proves the motion point. Keep the dynamic
portion aligned with the static card crop and typography.

When packaging is available, produce the platform package expected by the user's
publishing flow. When `.pvt` packaging is not available, deliver the verified
JPG/MOV pair and state the missing packaging step plainly.

### 6. Verify Before Delivery

Run a visual and file-level check:

- first frame works as a standalone social card
- duration matches the target platform (`3s` or `5s`)
- action is understandable without audio
- crop, safe areas, and text placement survive mobile viewing
- MOV/preview opens locally
- package was written to the task output folder
- delivery note explains that phone-side publishing may be required and desktop
  upload may not preserve Live Photo behavior

## Suitable Material

- product updates and AI tool demos where a click or generated result matters
- webpage, code, image, or UI generation proof
- one game action, timing, route, or success moment
- one tutorial step that needs motion evidence
- travel, lifestyle, food, craft, and product-detail clips with natural motion
- several parallel product states, model outputs, or detail angles

Motion should provide evidence. If it only decorates the card, use a static card.

## Stop Conditions

Stop or switch format when:

- the user wants a long-form video, full tutorial, or edited reel
- the source requires audio or narration to make sense
- the best segment cannot be chosen without user judgment
- the media is not user-owned or licensed for the requested use
- platform packaging tooling is unavailable and the user requires a ready-to-post
  phone package
- the output would need cloning upstream templates or assets with incompatible
  licensing

## Provenance

This local skill is adapted from public methodology signals in an X post and
GitHub README by `op7418`, but it does not import upstream files, templates,
assets, scripts, or skill text. See `references/source-intake.md`.
