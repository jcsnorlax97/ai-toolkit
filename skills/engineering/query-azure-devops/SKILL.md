---
name: query-azure-devops
description: Query work items and pull requests from an Azure DevOps organization. Use when asked to pull tickets, stories, support requests, PRs, or activity summaries from Azure DevOps. Encodes the correct tech-path discovery sequence so you do not waste turns on dead ends.
status: trial
problem: Azure DevOps work item and PR lookups often waste time on web fetches or unrelated Azure infrastructure tooling before using the Azure CLI path that actually works.
when-not-to-use: Do not use for GitHub-hosted repositories, Azure infrastructure resources, or Azure DevOps questions that do not require querying work items, pull requests, or activity data.
maintainer: Justin Choi
---

# Query Azure DevOps

Azure DevOps is not reachable via WebFetch or generic MCP servers.
The correct path is the Azure CLI with the `azure-devops` extension.

## Tech-Path Discovery (run in order, stop at the first success)

```
1. WebFetch dev.azure.com/*              -> ALWAYS FAILS (redirects to MSFT login)
2. ToolSearch "azure devops mcp"         -> MISS - azure MCP covers infrastructure
                                            (Storage, Key Vault, Cosmos DB), not DevOps
3. Atlassian MCP                         -> MISS - surfaces Confluence only, no ADO
4. az account show                       -> PASS if Azure CLI is authenticated
5. az extension list | grep azure-devops -> PASS if the extension is installed
```

If step 4 or 5 fails, tell the user to run:
```sh
az login
az extension add --name azure-devops
```

## Query Work Items (WIQL)

```sh
az boards query \
  --wiql "SELECT [System.Id], [System.Title], [System.WorkItemType], [System.State], \
          [System.AssignedTo], [System.CreatedDate], [System.ChangedDate] \
          FROM WorkItems \
          WHERE [System.AssignedTo] = '<email>' \
            AND [System.ChangedDate] >= '<YYYY-MM-DD>' \
            AND [System.ChangedDate] <= '<YYYY-MM-DD>' \
          ORDER BY [System.ChangedDate] DESC" \
  --organization https://dev.azure.com/<org> \
  --project <project> \
  --output json
```

Useful WIQL fields: `[System.WorkItemType]`, `[System.State]`, `[System.Tags]`, `[System.IterationPath]`, `[Microsoft.VSTS.Common.ClosedDate]`.

**Post-processing — remove false positives:** `System.ChangedDate` fires on any field edit, including bulk admin operations, iteration moves, and comments. This can pull in old items that were merely touched rather than actively worked on. After fetching, discard any item where **all three** of these are true:

1. `System.CreatedDate` is more than ~1 year before the period start
2. State is terminal (`Closed`, `Resolved`, `Removed`, `Pending Approval`, `Pending Prod Deployment`)
3. The title or context doesn't suggest it was genuinely completed this period

Use `--output json` (not `--output table`) so `System.CreatedDate` is visible for this check.

## Query Pull Requests

```sh
# PRs authored by a user
az repos pr list \
  --creator "<email>" \
  --organization https://dev.azure.com/<org> \
  --project <project> \
  --status all \
  --top 50 \
  --output table

# PRs where a user was added as reviewer
az repos pr list \
  --reviewer "<email>" \
  --organization https://dev.azure.com/<org> \
  --project <project> \
  --status all \
  --top 50 \
  --output table
```

Note: `--reviewer` matches both individual reviewers and team reviewers whose membership
includes the user. Filter by `Created` date after the fact to scope a date range.

## Rules

- Verify `az account show` before running any `az boards` or `az repos` call.
- The `azure` MCP server (`@azure/mcp`) is for Azure infrastructure — do not search for
  Azure DevOps tools there; they do not exist in that server.
- GitHub PRs (repos hosted on github.com, not dev.azure.com) require a separate tool
  (`gh` CLI or GitHub MCP). If neither is available, search Slack for PR links.
- When a project is unknown, run `az devops project list --organization <org>` to enumerate.
