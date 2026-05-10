# Methodology

## Experimental Design

The artefact compares two network architectures built from the same container image and service roles.

The flat baseline places all internal hosts on `10.10.0.0/24`, behind a firewall with an external attacker network at `192.168.100.0/24`.

The segmented design separates roles into distinct subnets:

| Segment | Subnet | Representative hosts |
| --- | --- | --- |
| Student | `10.10.10.0/24` | `seg-student`, `seg-student2` |
| Staff | `10.10.20.0/24` | `seg-staff` |
| Admin | `10.10.30.0/24` | `seg-admin` |
| Server | `10.10.40.0/24` | `seg-web`, `seg-file`, `seg-db` |
| IoT | `10.10.50.0/24` | `seg-iot` |
| Guest | `10.10.60.0/24` | `seg-guest` |
| External | `192.168.200.0/24` | `seg-attacker` |

Both scenarios include student, staff, admin, web, file, database, IoT, guest, attacker, and firewall roles. The main independent variable is the network architecture and firewall policy.

## Policy Model

The segmented policy permits only required flows:

- External attacker to public web service on TCP/80.
- Student to web on TCP/80.
- Staff to web on TCP/80 and file service on TCP/445.
- Admin to web on TCP/80, file service on TCP/445, and database on TCP/3306.
- IoT and guest to web on TCP/80.

All other forwarded traffic is dropped unless it is part of an established connection.

The flat baseline allows broad internal forwarding, representing a less restrictive internal network.

## Measurements

### Connectivity Policy Accuracy

`scripts/connectivity_test.sh` tests a fixed set of expected allowed and blocked flows. Each test records:

- scenario
- source container
- target host and IP
- protocol and port
- expected decision
- actual decision
- pass/fail
- response time in milliseconds

Policy accuracy is calculated as:

```text
passed_tests / total_tests * 100
```

### Blast-radius Exposure

`scripts/blast_radius_test.sh` models a compromised student host and tests reachability to other roles. Exposure is calculated as:

```text
reachable_targets / total_targets * 100
```

Containment is calculated as:

```text
100 - exposure
```

### HTTP Availability And Performance

`scripts/performance_test.sh` sends 500 HTTP requests from four client roles per scenario to the web service. It records HTTP status code and total response time.

Availability is calculated as:

```text
successful_http_200_responses / total_requests * 100
```

The performance score is calculated in `scripts/summarise_results.py` as:

```text
max(0, 100 - average_response_time_seconds * 1000)
```

### Reliability Index

The final reliability index combines the measured properties:

```text
0.30 * availability
+ 0.35 * containment
+ 0.25 * connectivity_policy_accuracy
+ 0.10 * performance_score
```

These weights prioritise containment and availability while still accounting for policy correctness and response-time overhead.

## Limitations

This is a controlled lab rather than a production network. It measures reachability, service availability, and simple response time under scripted conditions. It does not model realistic user traffic, IDS/IPS behaviour, credential compromise, application-layer vulnerabilities, or long-duration operational failure modes.

