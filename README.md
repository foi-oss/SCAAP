# SCAAP

SCAAP is a set of docker containers that contain analysis tools in order to discover critical bugs, vulnerabilities or formatting errors via static code analysis for different platforms. The general idea is to provide a pipeline for automating static code analysis for different platforms such as smart contracts, android apps, web apps, etc. This way, static code analysis requires zero to minimum configuration and can be used as a 'one line' command from the shell.

## Information for contributors

If you are willing to contribute to this project please keep in mind the following:

- Project is structured in a way that every platform is a separate folder
- Each platform should contain a `README.md` with instructions on how to use the scripts
- General idea for each platform is:
  1. Provide a Dockerfile for building a container
  1. Provide an internal script which will execute from inside a container and generate reports for each and every one of the tools - improvements can be made to pull one report in the end but this is still in discussion
  1. Provide an external script which will be run from outside of the container to start the analysis and pull the report(s) as well as the log file
  1. Additional scripts/files can be provided to fully automate the process
- Please use the GitHub repository as a place for suggesting improvements or reporting issues
- This is still the initial phase, so changes to the flow are highly likely to happen 
