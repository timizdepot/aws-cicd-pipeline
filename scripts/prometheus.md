    - job_name: 'nodes'
        static_configs:
        - targets:
            - "grafana-ne.timizus.com"
            - "jenkins-ne.timizus.com"
            - "nexus-ne.timizus.com"
            - "sonarqube-ne.timizus.com"
            - "dev-ne.timizus.com"
            - "stage-ne.timizus.com"
            - "prod-ne.timizus.com"
    - job_name: 'jenkins'
        metrics_path: /prometheus/
        static_configs:
        - targets: ["jenkins.timizus.com"]