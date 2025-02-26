## General

1. Docker resources are in the docker folder I uploaded it to ghcr.io instead of dockerhub as my dockerhub is for my opensource projects.
2. For the previously created image

   - Build Times: 188.0s (locally - fresh)
   - Improvements:
     - Improve layer optimization based on which parts frequently change
     - More agressive caching options
     - Larger Runners (depending on Application Architecture and bottlenecks)
     - Identifying unused dependencies
     - Slimmer custom base image

3. Scans are available in the action summary

   - Create a report of your findings and follow best practices to remediate the CVE
     - Scan is available in the github action summary
     - Identifying if a CVE is applicable would require more information on requirements and how the software will be interacted with.
     - Would require removing python2 (in order to use a newer debian version) which I believe is a requirement
   - What would you do to avoid deploying malicious packages?
     - The github action here is multi stage and depending on the branch will prevent deployments based on scan results
     - Dependency Monitoring
     - Developer Education/Assistance
     - Staying updated on Security related news/events

4. Kubernetes resources are in the k8s folder
5. Assuming a gateway is already configured (ie. istio) there's an http route in the k8s folder. Would use ingress otherwise.
6. CI/CD:
   - Github Actions to build and push images (ideally to ECR).
   - For deployments I would use an ArgoCD Applicationset and change the k8s directory into a helm chart.
   - Then based on the kind of workflow we want there are options.
   - For dev/testing I like using the PR Generator to allow devs to easily spin up their own environments (there should be automation around spinning them down to save on cost as well.)
   - For Prod/Staging I like using the git file generator and having a deployments repo (or tracking deployments in the same repo as the code if needed).
   - Depending on developer buy in at that point we could look at if there should be further abstractions on top of that.
   - This would also need project permissions setup correctly so that we can insure they're deployed to the correct environments and that we can follow least-privileges for interacting with those deployments
7. Monitoring the Deployment
   - Previously I've used kube-prometheus-stack in order to monitor deployments with alerts to slack with channels for actionable issues and non-actionable issues

## Kubernetes

1. ArgoCD Provides a quick way of enabling this for technical users. For non technical users I've had some success with a custom backstage plugin but creating a UI for this would definitely be doable.
   - For ArgoCD, using an applicationset to deploy a helm chart based on environment is easy enough. Having a deployments folder with configs that can be overwritten was used for longer term environments at my previous position and was fairly popular.
2. Using a combination of prometheus alerts and a hpa, enabling this should be fairly straightforward.
   - https://medium.com/engineering-housing/auto-scaling-based-on-prometheus-custom-metrics-688a92e0a796 for example
   - Using ArgoCD or an abstraction in front of it that interacts with a git repo would take care of this. You would need to corelate the usage with a specific user by adding metadata for who deploys it and then could filter for that metadata in prometheus/grafana/etc in order to create a dashboard to track it.
3. Taken care of with the above.
4. Previously a combination of cert-manager and external-dns has worked well for this. I would see if ssh/sftp access is absolutely required as well or if there are other solutions as I dislike the idea of having the nodes accessible.
5. 1. Previously I've utilized cache disks (pvcs with persistent data for bootstrapping) and startup jobs to bootstrap data that was needed but those data sets were much smaller so I doubt they would scale for this.
   2. - I haven't had to deal with that issue before so it would take a fair amount of time to learn and architect. I know of some tools in the space like Apache Spark and Dask but have not used them.
      - Since I don't have experience with these tools or requirements I wouldn't be able to Architect this on my own without lots of research and testing. Reaching out to a team member with experience for direction would be my first step here.
      - If I was to have to architect this myself without assistance or guidance
        - I would start by searching to see what others in the space are using in order to see what tooling is available.
        - I would also check the CNCF Landscape to see what FOSS tooling is available.
        - If I find something that seems viable, I would see what the requirements are and work on getting them deployed, then testing them myself.
        - If it looks good to me through my testing, I would talk to some trusted, more technical users to see if they would be able to offer insight, feedback, etc.
        - If at that point it looks viable, I would get the Production requirements together as well as documentation on how to use the system, and start working to introduce it to the dev/research teams.
   3. Memory
      - Memory Usage Metrics
        - Track RSS, heap usage, garbage collection metrics
        - Monitor swap usage and page faults
        - Set up alerts for memory pressure
      - Performance Profiling
        - Implement periodic heap dumps and analysis
        - Track processing time per data chunk
        - Monitor network I/O for distributed systems
