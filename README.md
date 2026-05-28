# day03-data

Environmental and economic data for EIL Summer 2026 research project.

## Project Structure

```
project_root/
├── code/
│   ├── logs/           # Log files generated during runs
│   └── programs/
│       └── module/     # Scripts organized by module
├── data/
│   ├── documentation/  # Codebooks, data dictionaries, source info
│   ├── clean/          # Cleaned/intermediate data
│   └── processed/      # Final analysis-ready data
├── analysis/           # Exploratory analysis files
├── results/
│   ├── figures/        # Output figures
│   ├── tables/         # Output tables
│   └── statistics/     # Summary statistics
├── paper/              # Draft manuscript files
├── run.do              # Master run file
├── global_paths.do     # Global path definitions
└── TODO.md             # Outstanding tasks
```

## How to Run

1. Open `global_paths.do` and set `global root` to your local project path.
2. Run `run.do` to execute the full pipeline.

## Data Sources

- [Add source 1]
- [Add source 2]
