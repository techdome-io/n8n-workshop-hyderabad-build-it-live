# Event workflows

Two workflows, each built live in 3 parts. **Part 1 of each is imported automatically** the first time n8n starts. Parts 2 and 3 are added during the workshop.

| Workflow | Part 1 (auto-imported) | Part 2 | Part 3 |
|---|---|---|---|
| **AI Lead Intelligence and Qualification** | `1_lead_intelligence_part1_...` | `2_lead_intelligence_part2_...` | `3_lead_intelligence_part3_...` |
| **Employee Request and Approval Router** | `1_employee_router_part1_...` | `2_employee_router_part2_...` | `3_employee_router_part3_...` |

Parts 2 and 3 refer to nodes from the earlier parts, so they cannot be imported as stand-alone workflows. To add one: open the JSON file, copy everything (Ctrl+A, Ctrl+C), click the canvas of your workflow, paste (Ctrl+V), then connect the new nodes as the sticky note says.

| Needs | Where |
|---|---|
| Your own **Apify** account (free tier) | Lead Intelligence, Part 1 |
| The workshop **OpenAI key + Base URL** | Lead Intelligence, Part 2 |
| Your own email as approver | Employee Router, Part 1 (4 queue nodes) |

The Data Tables `leads` and `employee_requests` are created automatically on first start.
