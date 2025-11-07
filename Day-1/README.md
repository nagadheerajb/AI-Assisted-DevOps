# VM Health Check Script

This repository contains a shell script (`vm_health_check.sh`) to analyze the health of an Ubuntu virtual machine based on CPU, memory, and disk space utilization.

## Features

- Checks CPU, memory, and disk usage.
- Declares VM as **Healthy** if all resources are below 60% utilization.
- Declares VM as **Not healthy** if any resource exceeds 60% utilization.
- Supports an `explain` argument to show detailed reasons for health status.

## Usage

1. **Clone the repository** and navigate to the script directory.

2. **Make the script executable:**

   ```bash
   chmod +x vm_health_check.sh
   ```

3. **Run the script:**

   ```bash
   ./vm_health_check.sh
   ```

4. **Run with explanation:**
   ```bash
   ./vm_health_check.sh explain
   ```

## Output

- **Healthy:** All resources are below 60% utilization.
- **Not healthy:** At least one resource exceeds 60% utilization.
- With `explain`, the script prints the utilization values and reasons for the health status.

## Requirements

- Ubuntu VM
- Bash shell
- Standard utilities: `top`, `free`, `df`, `awk`, `sed`, `bc`

## Example

```bash
$ ./vm_health_check.sh
Healthy

$ ./vm_health_check.sh explain
Healthy
All resources are below 60% utilization.
CPU: 15.0% | Memory: 40.00% | Disk: 6%
```

## License

This project is licensed under the MIT License.
