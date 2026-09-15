---
name: simple-lang
description: Rewrite product UI copy in plain end-user language. Use this whenever editing labels, headings, help text, empty states, buttons, cards, tables, filters, or error messages, especially when copy includes technical terms, internal system names, code words, database words, protocol names, or business jargon.
user-invokable: true
args:
  - name: target
    description: The page, component, or copy to simplify
    required: false
---

# Simple Lang

Write UI copy that any everyday user can understand quickly.

The product may be technical internally, but the interface should sound like a clear person explaining what the user can see or do.

## Core Rule

Do not expose implementation details in user-facing copy.

Avoid words like:

- tenant
- schema
- registry
- pipeline
- persisted
- configured, when "set up" is clearer
- MQTT
- API
- payload
- device-control
- policy, unless the screen is explicitly for policy experts
- geofence, when "allowed area" or "location area" is clearer
- node, fleet node, runtime, sync, artifact, manifest

Use the user's language instead:

- "workspace" instead of "tenant"
- "saved" instead of "persisted"
- "set up" instead of "configured"
- "terminal" or "device" instead of "node"
- "allowed area" instead of "geofence policy"
- "save changes" instead of "push the policy"
- "online now" instead of "actively reporting presence"

## How To Rewrite

1. Identify the user's goal on the screen.
2. Replace internal nouns with visible real-world nouns.
3. Replace system actions with user actions.
4. Keep sentences short.
5. Prefer one clear sentence over a clever phrase.
6. Remove details users do not need to complete the task.

## Good Examples

Bad: "Live fleet nodes visible in geofence management"  
Good: "Terminals with a saved location"

Bad: "Push the updated policy through the existing device-control pipeline"  
Good: "Save the allowed area for this terminal"

Bad: "Tenant merchant registry"  
Good: "Saved merchants"

Bad: "POS transaction monitoring from MQTT terminal reports"  
Good: "Track transactions from your terminals"

## Checks Before Finishing

- Could a non-technical operations user understand it without training?
- Does it avoid code words and system names?
- Is it shorter than the original?
- Does it tell the user what they can see or do?
- Is the same thing called the same name across the page?

If the copy still sounds like a database, protocol, or backend service, rewrite it again.
