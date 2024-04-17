# Getting Started

This guide gives a general overview to the `compliance` gem, and how to track requirements and attestations across projects with dependencies.

## Installation

Add the gem to your project:

~~~ bash
$ bundle add compliance
~~~

## Core Concepts

The `compliance` gem provides a framework for tracking requirements and attestations across projects with dependencies, and validating that the requirements are met using a policy.

- A {ruby Compliance::Requirement} instance represents a specific requirement.
- A {ruby Compliance::Attestation} instance represents an attestation of a requirement.
- A {ruby Compliance::Policy} instance represents a policy which can be used to validate requirements against attestations. A policy might take into account the context of the project, such as the environment, time, or other factors.

## Integration

By default the `compliance` gem loads requirements and attestations from all dependencies, including the project itself. For each source root, the loader looks for a `compliance.json` file, along with a `compliance` directory containing `*.json` files. All of these files get loaded into a single document, combining all requirements and attestations. Validation is performed by using a policy to check that all requirements have been met.

Typically, you'd expect to define requirements separately from attestations. You can do that by using a file in the `compliance/` directory, e.g. `compliance/project.json`:

~~~ json
{
	"requirements": [
		{
			"id": "PRJ-1",
			"description": "The project must have a readme file."
		},
		{
			"id": "PRJ-2",
			"description": "The project must have a license file."
		}
	]
}
~~~

This file defines the requirements for your project. You can then create attestations for these requirements in another file, e.g. `compliance.json`:

~~~ json
{
	"attestations": [
		{
			"id": "PRJ-1",
			"by": "Alice",
		}
	]
}
~~~

This file defines an attestation for the `PRJ-1` requirement. Given the above files, the policy would not be satisfied as the `PRJ-2` requirement has not been attested.

The metadata you attach to requirements and attestations is up to you. The `compliance` gem doesn't enforce any particular structure, but it does provide a framework for loading and validating requirements and attestations. If you want to enforce a specific structure, you should subclass {ruby Compliance::Policy}.

### General Guidelines

A library that provides functionality may like to publish attestations against general frameworks for security, privacy, or other concerns. For example, a library that handles personal data may publish attestations against the GDPR.

A service (or application) that uses a library should include the library's attestations in its own compliance document. This way, the service can demonstrate that it is using the library in a compliant manner. In addition, the service may have its own requirements and attestations, or may pull in a gem dedicated to a specific compliance framework.
