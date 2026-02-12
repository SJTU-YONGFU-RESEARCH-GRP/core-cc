# IEEE Data Descriptor Paper Drafting Prompt

## Master Prompt for Complete Paper

```
You are writing an IEEE Data Descriptor paper for the core-cc project. Follow the instructions in docs/IEEE_DATA_DESCRIPTOR_INSTRUCTIONS.md strictly.

TASK: Draft a complete IEEE Data Descriptor paper by analyzing the entire codebase.

REQUIREMENTS:
1. Read and analyze the following files first:
   - README.md for project overview
   - All documentation in docs/
   - Main source code files to understand data collection
   - Configuration files for system setup
   - Any validation or test files
   - Dependency files (requirements.txt, package.json, etc.)

2. For each section, include:
   - Actual content based on codebase analysis
   - [FIGURE X: Description] placeholders where diagrams are needed
   - [TABLE X: Description] placeholders where tables are needed
   - [X] citation placeholders where references are needed
   - Version numbers for all software/libraries

3. Draft all sections in order:
   - Abstract
   - Background
   - Collection Methods and Design
   - Validation and Quality
   - Records and Storage
   - Insights and Notes
   - Source Code and Scripts
   - Acknowledgements and Interests
   - References (minimum 10)

4. After drafting, provide a summary of:
   - Placeholders that need content (figures, tables, citations)
   - Information that couldn't be found in codebase
   - Sections that need human review

Begin by reading the codebase and then draft each section systematically.
```

---

## Section-by-Section Prompts

### PROMPT 1: Abstract

```
Analyze the core-cc project codebase and write the Abstract section for an IEEE Data Descriptor paper.

ANALYSIS REQUIRED:
1. Read README.md to understand project purpose and scope
2. Examine main data collection/processing scripts
3. Identify the type and scale of data collected
4. Determine primary applications and use cases

OUTPUT REQUIREMENTS:
- 150-250 words
- Clear description of what data is collected
- Statement of the data's value and potential applications
- Unique characteristics of this dataset
- Include [X] for citations where needed

Write the abstract now.
```

---

### PROMPT 2: Background

```
Write the Background section for the core-cc project IEEE Data Descriptor paper.

ANALYSIS REQUIRED:
1. Review README.md and all documentation in docs/
2. Understand the problem domain and motivation
3. Identify what makes this dataset unique
4. Research similar datasets in this domain (note: you may need to suggest where citations are needed)

OUTPUT REQUIREMENTS:
- Overview of the data collected
- Comparison with other published datasets [add citations as [X]]
- Clear value proposition for reuse
- Summary of any previous uses (if found in docs)
- DO NOT include paragraph about paper organization
- Provide at least 5-7 citation placeholders for:
  * Related datasets
  * Domain-specific papers
  * Previous work in this area

STRUCTURE:
Paragraph 1: Problem context and motivation
Paragraph 2-3: Comparison with existing datasets [cite similar works]
Paragraph 4: Unique value and contribution
Paragraph 5: Previous publications using this data (if any)

Write the Background section now.
```

---

### PROMPT 3: Collection Methods and Design

```
Write the Collection Methods and Design section for the core-cc project.

ANALYSIS REQUIRED:
1. Identify and read all data collection scripts
2. Examine configuration files for system parameters
3. Trace the data flow from source to storage
4. Review any preprocessing or transformation code
5. Identify hardware/sensors/APIs used

OUTPUT REQUIREMENTS:
- Detailed description of hardware/system setup
- Step-by-step data collection procedures
- Computational processing pipeline
- Include these placeholders:
  * [FIGURE 1: System Architecture Diagram - Show hardware components, data sources, and data flow]
  * [FIGURE 2: Data Collection Workflow - Show step-by-step process from acquisition to storage]
- Add [X] citations for:
  * Hardware/sensor specifications
  * APIs or data sources used
  * Algorithms or methods referenced

STRUCTURE:
1. Hardware and System Setup
   - List all hardware components with specifications
   - System configuration details
   - [FIGURE 1] placeholder

2. Data Collection Procedure
   - Detailed step-by-step process
   - Sampling methodology and frequency
   - Time period of collection

3. Data Processing Pipeline
   - Preprocessing steps
   - Transformation algorithms [cite if needed]
   - Quality control during collection
   - [FIGURE 2] placeholder

List specific files analyzed and write the section.
```

---

### PROMPT 4: Validation and Quality

```
Write the Validation and Quality section for the core-cc project.

ANALYSIS REQUIRED:
1. Find and analyze validation scripts or test files
2. Look for quality metrics calculations in the code
3. Examine error handling and data cleaning procedures
4. Calculate or extract quality statistics from code
5. Review any documented validation procedures

OUTPUT REQUIREMENTS:
- Technical quality metrics with specific values
- Accuracy measurements and error rates
- Validation procedures performed
- Include these placeholders:
  * [TABLE I: Summary Statistics - Include mean, std, min, max, missing values for key variables]
  * [TABLE II: Data Quality Metrics - Include completeness %, accuracy, consistency checks]
  * [FIGURE 3: Data Distribution Plots - Show distributions of key variables]
  * [FIGURE 4: Quality Metrics Over Time - If temporal data, show quality trends]
- Add [X] citations for:
  * Validation methods used
  * Quality standards or benchmarks referenced
  * Statistical tests applied

STRUCTURE:
1. Data Quality Overview
   - Completeness statistics
   - [TABLE I] placeholder

2. Validation Procedures
   - Methods used to verify quality
   - Accuracy measurements [cite validation approaches]

3. Quality Metrics
   - Specific error rates or uncertainties
   - [TABLE II] placeholder
   - [FIGURE 3] and [FIGURE 4] placeholders

List validation code found and write the section with specific metrics.
```

---

### PROMPT 5: Records and Storage

```
Write the Records and Storage section for the core-cc project.

ANALYSIS REQUIRED:
1. Explore the data directory structure
2. Examine data model definitions and schema files
3. Review data export/save functions to understand formats
4. Identify all data files in the dataset
5. Understand relationships between files

OUTPUT REQUIREMENTS:
- Complete listing of all data files
- Detailed schema for each file type
- Explanation of file relationships and hierarchies
- Include these placeholders:
  * [TABLE III: Data Files Summary - Columns: Filename, Format, Size, Records, Description]
  * [TABLE IV: Data Schema for [Primary File] - Columns: Field Name, Data Type, Unit, Description, Example]
  * [TABLE V: Data Schema for [Secondary File] - Similar structure]
  * [FIGURE 5: File Relationship Diagram - If complex relationships exist]

STRUCTURE:
1. Storage Overview
   - Overall organization approach
   - Total dataset size
   - [TABLE III] placeholder with actual filenames if found

2. File Format Details
   For each major file:
   - Format (CSV, JSON, Parquet, etc.)
   - Complete schema description
   - [TABLE IV], [TABLE V], etc. placeholders

3. Relationships and Hierarchies
   - How files connect to each other
   - Any aggregated or derived files
   - [FIGURE 5] placeholder if needed

Examine the data directory structure and write the section with actual file details.
```

---

### PROMPT 6: Insights and Notes

```
Write the Insights and Notes section for the core-cc project.

ANALYSIS REQUIRED:
1. Review code comments for noted limitations
2. Check documentation for known issues or caveats
3. Examine edge case handling in the code
4. Consider alternative applications based on data characteristics

OUTPUT REQUIREMENTS:
- Important caveats and limitations
- Special usage considerations
- Alternative applications beyond primary purpose
- Add [X] citations where alternative methodologies are mentioned

STRUCTURE:
1. Caveats and Limitations (2-3 paragraphs)
   - Known issues or biases
   - Scope limitations
   - Data coverage gaps

2. Special Usage Notes (1-2 paragraphs)
   - Edge cases to be aware of
   - Special handling requirements

3. Alternative Applications (2-3 paragraphs)
   - Cross-domain uses
   - Methodological testing opportunities [cite relevant methods]
   - Future extension possibilities

Be creative about alternative uses while grounding in actual data characteristics.
```

---

### PROMPT 7: Source Code and Scripts

```
Write the Source Code and Scripts section for the core-cc project.

ANALYSIS REQUIRED:
1. Read all dependency files (requirements.txt, package.json, Pipfile, etc.)
2. Check README for software requirements and setup instructions
3. Review import statements across all code files
4. Identify programming languages and versions used
5. Note any commercial or specialized software
6. Find repository URLs and version tags

OUTPUT REQUIREMENTS:
- All code repositories with URLs
- Complete list of dependencies WITH VERSION NUMBERS
- Programming languages with versions
- Include these placeholders:
  * [TABLE VI: Key Scripts and Functions - Columns: Script Name, Purpose, Language]
  * [TABLE VII: Software Dependencies - Columns: Library, Version, Purpose, License]
- Add [X] citations for:
  * Major libraries and frameworks
  * Third-party tools
  * Code repository DOIs (if available)
- DO NOT include dataset DOI here

STRUCTURE:
1. Code Repositories
   - GitHub/GitLab URLs
   - Commit hashes or version tags
   - [TABLE VI] placeholder

2. Programming Environment
   - Languages and versions
   - Development environment details

3. Dependencies
   - [TABLE VII] placeholder with complete list
   - Must include version numbers for everything

4. Third-Party Software
   - Commercial tools (with versions)
   - Online services or APIs used

Extract actual version numbers from dependency files and write the section.
```

---

### PROMPT 8: Acknowledgements and References

```
Write the Acknowledgements and Interests section, then compile the References section.

ANALYSIS FOR ACKNOWLEDGEMENTS:
1. Check README for funding information
2. Review CONTRIBUTORS or AUTHORS files
3. Look for grant numbers or institutional support

OUTPUT FOR ACKNOWLEDGEMENTS:
- Funding sources with grant numbers (if found)
- Institutional support
- Standard conflict of interest statement

ANALYSIS FOR REFERENCES:
1. Collect all [X] citation placeholders from previous sections
2. Check README and docs for cited papers
3. Look for CITATION.cff or similar files

OUTPUT FOR REFERENCES:
- List all citation placeholders from the paper (minimum 10)
- For each placeholder, provide:
  * Suggested citation type (paper, software, dataset, etc.)
  * What it should cite (e.g., "Cite adaptive coding algorithm paper")
  * IEEE format template
- Group by category:
  * Background and related work
  * Methods and algorithms
  * Software and libraries
  * Hardware and equipment
  * Standards and protocols

Example output:
[1] PLACEHOLDER - Cite related error correction dataset
[2] PLACEHOLDER - Cite BCH algorithm original paper
[3] PLACEHOLDER - Cite Python SciPy library
...

Provide the Acknowledgements section and the complete reference list with placeholders.
```

---

## Post-Drafting Review Prompt

```
Review the complete IEEE Data Descriptor paper draft and provide:

1. COMPLETENESS CHECK:
   - [ ] All 9 sections present in correct order
   - [ ] No section numbering used
   - [ ] Abstract is 150-250 words
   - [ ] Background has no "organization" paragraph
   - [ ] At least 10 references

2. PLACEHOLDER SUMMARY:
   Create a checklist of all placeholders:
   - Figures needed (with descriptions)
   - Tables needed (with required data)
   - Citations needed (with topics)

3. MISSING INFORMATION:
   List any information that couldn't be found in the codebase that needs human input.

4. VERSION NUMBER CHECK:
   Verify all software has version numbers listed.

5. REQUIRED ELEMENTS:
   - [ ] Validation section has figures/tables
   - [ ] Records section describes all data files
   - [ ] Source Code section has all dependencies with versions
   - [ ] Minimum 10 reference placeholders

Provide the review checklist now.
```

---

## Quick Reference: Citation Topics to Cover

Ensure citations are suggested for:

**Background Section:**
- [ ] Similar datasets in the domain (3-5 citations)
- [ ] Related work and previous publications (2-3 citations)
- [ ] Domain-specific foundational papers (2-3 citations)

**Collection Methods:**
- [ ] Hardware specifications or manuals
- [ ] API documentation
- [ ] Algorithms used (e.g., BCH codes, adaptive coding)

**Validation:**
- [ ] Validation methodology papers
- [ ] Quality metrics standards
- [ ] Statistical methods used

**Source Code:**
- [ ] All major libraries (NumPy, Pandas, etc.)
- [ ] Frameworks used
- [ ] Code repository (with DOI if available)

---

## Tips for Best Results

1. **Start with codebase exploration**:
   ```
   First, read the following files to understand the project:
   - /home/kiankit/github_projects/core-cc/README.md
   - /home/kiankit/github_projects/core-cc/docs/*.md
   Then draft [section name].
   ```

2. **Be specific about what to extract**:
   "Extract actual version numbers from dependency files"
   "List actual filenames found in the data directory"

3. **Request placeholder details**:
   "For each figure placeholder, describe what content it should show"

4. **Ask for verification**:
   "After writing, list which files you analyzed to create this section"

5. **Iterate section by section**:
   Review each section before moving to the next to ensure quality

---

## Example Complete Workflow

**Step 1**: Use PROMPT 1 to draft Abstract
**Step 2**: Review Abstract, then use PROMPT 2 for Background
**Step 3**: Continue through PROMPT 7 sequentially
**Step 4**: Use PROMPT 8 for final sections
**Step 5**: Use Post-Drafting Review Prompt
**Step 6**: Fill in placeholders with actual content
**Step 7**: Add proper citations to replace [X] markers

---

## Output Format Expected

Each section should be output as:

```markdown
## [Section Name]

[Content with proper paragraphs and structure]

[FIGURE X: Detailed description of what the figure should show]

[TABLE X: Description]
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Data     | Data     | Data     |

[Additional content with [X] for citations]

### Files Analyzed for This Section:
- file1.py
- file2.md
- config.json
```

This helps track what was analyzed and ensures transparency.

