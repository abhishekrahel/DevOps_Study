# AI Kubernetes Application Failure Analysis

## Overall Status
Deployment `html-app` in namespace `qa` is unhealthy. The Deployment has 1 desired replica but 0 available; the single Pod is Pending with `ImagePullBackOff` and has never started. Rollout is not progressing (Progressing: False — ProgressDeadlineExceeded).

## Root Cause
Most likely root cause: the Deployment references a non-existent or inaccessible container image tag (`449957914366.dkr.ecr.us-east-1.amazonaws.com/dev-nginx-repo:wrong-tag`), causing the kubelet to fail pulling the image and enter `ImagePullBackOff`.

Note: the diagnostics do not include the exact registry error string (e.g., "manifest unknown" vs "access denied"), so we cannot definitively distinguish between "image not found" and "authentication/authorization" issues. The image name/tag mismatch is the most probable cause based on the provided data.

## Supporting Evidence
- Deployment configuration shows image: `449957914366.dkr.ecr.us-east-1.amazonaws.com/dev-nginx-repo:wrong-tag`.
- ReplicaSet `html-app-6d7dc7f89f` reports 1 current / 1 desired replica but 0 Ready.
- Pod `html-app-6d7dc7f89f-qhpcj` status:
  - READY 0/1, STATUS `ImagePullBackOff`
  - Container state Waiting — Reason: `ImagePullBackOff`
  - Events (repeated):
    - `Back-off pulling image "449957914366.dkr.ecr.us-east-1.amazonaws.com/dev-nginx-repo:wrong-tag"`
    - `Error: ImagePullBackOff`
- Deployment conditions:
  - Available: False — Reason: MinimumReplicasUnavailable
  - Progressing: False — Reason: ProgressDeadlineExceeded
- Pod logs unavailable: "Container never started or image could not be pulled."
- No additional image-pull failure details (e.g., registry HTTP error, 403/404) are present in the provided diagnostics.

## Business Impact
- The `html-app` service currently has 0/1 available pods; the application is not serving traffic.
- End users depending on this application (or QA/testing) will experience outages or inability to access the content served by this Pod until the image pull problem is resolved.
- Automated rollouts are stalled (deployment ProgressDeadlineExceeded), which may block further deployments or automated pipelines if they depend on a successful rollout.

## Resolution Steps
Follow these steps to restore the deployment. Execute from an account with kubectl and AWS CLI access as appropriate.

1. Confirm the image exists in ECR (replace `<correct-tag>` if known):
   - aws-cli:  
     aws ecr describe-images --repository-name dev-nginx-repo --image-ids imageTag=wrong-tag --region us-east-1
   - If the above returns "ImageNotFound" or "ImageNotFoundException", the tag does not exist.

2. If the tag is incorrect, update the Deployment to point to a valid image tag:
   - Example (replace `<correct-tag>` with the correct tag or digest):  
     kubectl -n qa set image deployment/html-app html-app=449957914366.dkr.ecr.us-east-1.amazonaws.com/dev-nginx-repo:<correct-tag>
   - Alternatively, edit the deployment:  
     kubectl -n qa edit deployment html-app

3. If the image exists but pull still fails, check registry access/permissions:
   - Inspect pod describe events for a clearer registry error:  
     kubectl -n qa describe pod html-app-6d7dc7f89f-qhpcj
   - If auth error appears (e.g., `access denied`), verify node/EKS permissions or imagePullSecrets:
     - For ECR on EKS, ensure nodes have the IAM role with ECR pull permissions, or imagePullSecrets/IRSA is configured.
     - Test node ability to pull: SSH to node (if allowed) and try `docker pull` or `crictl pull` using the fully-qualified image name after authenticating (`aws ecr get-login-password | docker login --username AWS --password-stdin 449957914366.dkr.ecr.us-east-1.amazonaws.com`).

4. After correcting image or auth, monitor rollout:
   - kubectl -n qa rollout status deployment/html-app
   - kubectl -n qa get pods -w

5. If a stuck Pod remains, delete it to force recreation after fix:
   - kubectl -n qa delete pod html-app-6d7dc7f89f-qhpcj

6. Verify successful deployment:
   - kubectl -n qa get deployment html-app
   - Confirm `Available` condition becomes True and Pod shows Ready.

7. If you need troubleshooting information not present here, collect:
   - Full `kubectl describe pod <pod>` output (already partially present).
   - `kubectl get events -n qa --sort-by=.metadata.creationTimestamp`
   - Node kubelet logs around the pull attempts and `crictl` or `docker` pull output on node.
   - ECR audit/registry logs to confirm pull attempt and error.

## Best Practices to Prevent Recurrence
- CI/CD: Ensure pipeline validates that the image was pushed to registry and that the deployment references an existing tag. Fail deployments if image push or registry tag verification fails.
- Use immutable identifiers: Deploy by image digest (sha256) rather than mutable tags to guarantee reproducibility.
- Taging policy: Avoid ad-hoc tags like `wrong-tag`; use semantically meaningful, automated tags from CI (e.g., commit SHA, semver).
- Pre-deployment checks: Add a pre-flight step to verify `docker manifest` / `aws ecr describe-images` for the referenced tag before applying Kubernetes manifests.
- Registry auth: For ECR on EKS, use appropriate mechanisms (node IAM role with ECR pull permissions or IRSA/imagePullSecrets) and periodically validate credential rotation.
- Observability & alerting: Alert on `ImagePullBackOff`, Deployment `ProgressDeadlineExceeded`, and low availability counts so teams are notified quickly.
- Health probes & readiness: Ensure liveness/readiness probes are configured so pods are only marked available when truly ready.
- Automation: Implement automated rollback and safe deployment strategies (canary, blue/green) to limit impact.

## Confidence Level
High.

Reason: The diagnostics explicitly show `ImagePullBackOff` for the Pod and the Deployment references the image tag `:wrong-tag`. These facts directly indicate an image-pull failure likely caused by the incorrect tag or registry access issue. However, the data does not include the precise registry error message (e.g., 404 vs 403), so while we are confident the immediate failure is an image pull problem, the exact sub-cause (non-existent tag vs auth) requires the additional checks listed in Resolution Steps.
