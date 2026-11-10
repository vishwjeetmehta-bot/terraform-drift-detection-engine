import sys
import os
import requests

def notify_drift(log_file):
    webhook_url = os.getenv("TEAMS_OR_SLACK_WEBHOOK_URL")
    if not webhook_url:
        print("No webhook URL configured. Skipping alert.")
        return

    with open(log_file, "r") as f:
        log_content = f.read()

    # Truncate if too long for card
    snippet = log_content[-1500:] if len(log_content) > 1500 else log_content

    payload = {
        "@type": "MessageCard",
        "@context": "http://schema.org/extensions",
        "themeColor": "E81123",
        "summary": "CRITICAL: Terraform Drift Detected in Production",
        "sections": [{
            "activityTitle": "🚨 Terraform State Drift Alert",
            "activitySubtitle": "Live cloud infrastructure has drifted from Git baseline",
            "facts": [
                {"name": "Environment", "value": os.getenv("ENVIRONMENT", "Production")},
                {"name": "Repository", "value": os.getenv("GITHUB_REPOSITORY", "IaC-Repo")},
                {"name": "Triggered By", "value": "Automated Drift Cron"}
            ],
            "text": f"```\n{snippet}\n```",
            "markdown": True
        }]
    }

    try:
        res = requests.post(webhook_url, json=payload, timeout=10)
        res.raise_for_status()
        print("Drift alert posted successfully.")
    except Exception as e:
        print(f"Failed to post drift alert: {e}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        notify_drift(sys.argv[1])

