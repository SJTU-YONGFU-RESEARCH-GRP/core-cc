# Instructions for Cursor AI Assistant: IEEE Data Descriptor Paper Writing

## Overview
This document provides comprehensive instructions for writing an IEEE Data Descriptor paper section by section. The AI assistant should follow these guidelines strictly while adapting content based on the project codebase.

---

## Paper Structure Requirements

**CRITICAL**: The paper MUST have ONLY these sections in this EXACT order (without section numbering):

1. Abstract (First Page Front-Matter)
2. Background
3. Collection Methods and Design
4. Validation and Quality
5. Records and Storage
6. Insights and Notes
7. Source Code and Scripts
8. Acknowledgements and Interests
9. References

---

## Section-by-Section Writing Instructions

### 1. ABSTRACT

**Purpose**: Concise summary of the entire data descriptor

**Requirements**:
- Brief overview of the dataset
- Key characteristics and scope
- Primary applications and value
- Length: Typically 150-250 words
- Must appear on the first page as front-matter

**Writing Strategy**:
- Examine the codebase to understand the data collection purpose
- Identify the main data types, sources, and scope
- Highlight unique aspects or contributions
- State potential applications clearly

**Questions to Answer**:
- What data was collected?
- Why is this data valuable?
- What can researchers do with this data?
- What makes this dataset unique?

---

### 2. BACKGROUND

**Purpose**: Establish context and demonstrate the dataset's value

**MUST Include**:
1. Overview of the data collected
2. How this dataset compares to other published datasets
3. Clear statement of the data's value and reuse potential
4. Summary of any previous publications using this data (with citations)

**MUST NOT Include**:
- Paragraph on how the article is organized (all articles follow the same structure)

**Writing Strategy**:
1. **Analyze Codebase**:
   - Review README.md for project overview
   - Examine main data collection scripts to understand scope
   - Check any documentation about data structure
   
2. **Research Context**:
   - Identify the domain/field of the dataset
   - Note what makes this dataset unique or valuable
   
3. **Structure**:
   - Paragraph 1: What problem/need does this data address?
   - Paragraph 2-3: How does this compare to existing datasets?
   - Paragraph 4: What is the unique value proposition?
   - Paragraph 5: Previous uses (if any) with citations

**Key Questions**:
- What gap does this dataset fill?
- What existing datasets are similar? How is this different/better?
- Why would researchers want to use this data?
- Has this data been used before? Where and how?

**Minimum References**: Expect at least 5-7 citations to related datasets and works

---

### 3. COLLECTION METHODS AND DESIGN

**Purpose**: Provide complete details on data collection methodology

**MUST Include**:
1. **Hardware/System Design**:
   - All hardware components used (sensors, devices, equipment)
   - System architecture and configuration
   - Data acquisition setup
   
2. **Data Collection Steps**:
   - Detailed procedures and workflows
   - Timeline and sampling methodology
   - Any protocols followed
   
3. **Data Processing**:
   - Computational processing steps
   - Algorithms or methods used
   - Transformation and cleaning procedures
   
4. **Diagrams**: System architecture and/or workflow diagrams (highly recommended)

**Writing Strategy**:
1. **Examine Codebase**:
   - Review data collection scripts (look for main entry points)
   - Identify data sources and APIs used
   - Check configuration files for system parameters
   - Review any pipeline or workflow scripts
   
2. **Create Diagrams**:
   - System architecture showing data flow
   - Workflow/pipeline diagram showing processing steps
   
3. **Structure**:
   - Subsection: Hardware and System Setup
   - Subsection: Data Collection Procedure
   - Subsection: Data Processing Pipeline
   - Include figures with detailed captions

**Key Questions**:
- What hardware/software systems were used?
- How was data acquired from sources?
- What was the sampling rate/frequency/methodology?
- What preprocessing was applied?
- What computational tools were used?
- Can someone reproduce this collection process?

**Code Analysis Focus**:
- Main collection scripts and their functions
- Configuration parameters
- API endpoints and data sources
- Processing pipelines and transformations

---

### 4. VALIDATION AND QUALITY

**Purpose**: Demonstrate technical quality and accuracy of the dataset

**MUST Include**:
1. Technical quality metrics
2. Accuracy measurements
3. Error rates or uncertainty estimates
4. Validation procedures performed
5. **Figures and Tables**: Supporting data quality metrics

**Writing Strategy**:
1. **Examine Codebase**:
   - Look for validation scripts or test files
   - Check for quality assurance functions
   - Identify any error checking or verification code
   - Review any statistical analysis or quality metrics
   
2. **Identify Metrics**:
   - Completeness (missing data rates)
   - Accuracy (if ground truth available)
   - Consistency checks
   - Data distribution statistics
   - Sensor/hardware error rates
   
3. **Create Figures/Tables**:
   - Table: Summary statistics for key variables
   - Figure: Data distribution plots
   - Figure: Quality metrics over time
   - Table: Validation test results

**Key Questions**:
- How accurate is the data?
- What are the error rates or uncertainty levels?
- What validation procedures were performed?
- Are there any quality issues or limitations?
- How complete is the dataset?
- Were any outliers detected and handled?

**Code Analysis Focus**:
- Validation functions and tests
- Quality metrics calculations
- Error checking procedures
- Statistical analysis scripts

---

### 5. RECORDS AND STORAGE

**Purpose**: Describe data file structure and storage organization

**MUST Include**:
1. **File Structure Details**:
   - Complete listing of all data files
   - Format of each file (CSV, JSON, Parquet, etc.)
   - Size and scope of each file
   
2. **Data Schema**:
   - For CSV: Description of all columns and rows
   - For JSON/XML: Schema structure
   - For databases: Table schemas and relationships
   - Data types for each field
   
3. **Hierarchical Relationships**:
   - How files relate to each other
   - Any derived or aggregated files
   - Dependencies between files
   
4. **Table Recommended**: Master table listing all files with:
   - Filename
   - Format
   - Size
   - Description
   - Number of records/rows

**Writing Strategy**:
1. **Examine Codebase**:
   - Check data directory structure
   - Review schema definitions or data models
   - Look for README files in data directories
   - Examine data loading/saving code
   
2. **Document Structure**:
   - Create comprehensive file listing table
   - Document each field/column with data type and description
   - Explain relationships and hierarchies
   
3. **Structure**:
   - Overview paragraph on storage approach
   - Master table of all data files
   - Detailed schema for each file type
   - Relationship diagram (if complex structure)

**Key Questions**:
- What files are included in the dataset?
- What format is each file?
- What does each field/column represent?
- How do files relate to each other?
- Are there any derived or summary files?
- What is the total size of the dataset?

**Code Analysis Focus**:
- Data model definitions
- Schema files
- Data export/save functions
- Database configurations
- File organization code

---

### 6. INSIGHTS AND NOTES

**Purpose**: Provide usage guidance, caveats, and additional applications

**MUST Include**:
1. **Caveats and Limitations**:
   - Known issues or biases
   - Limitations in scope or coverage
   - Special considerations for use
   
2. **Special Case Usages**:
   - Edge cases in the data
   - Unusual patterns or characteristics
   
3. **Alternative Applications**:
   - Other potential uses beyond primary purpose
   - Cross-domain applications
   - Theoretical or methodological uses

**Writing Strategy**:
1. **Examine Codebase**:
   - Review comments noting limitations
   - Check issue trackers or TODO comments
   - Look for edge case handling
   - Review documentation about known issues
   
2. **Think Broadly**:
   - What other research questions could this data answer?
   - What domains could benefit from this data?
   - What methodologies could be tested on this data?
   
3. **Structure**:
   - Paragraph 1-2: Important caveats and limitations
   - Paragraph 3-4: Special usage notes
   - Paragraph 5-6: Alternative applications and opportunities

**Key Questions**:
- What should users be careful about?
- What are the limitations?
- What other ways could this data be used?
- What unexpected insights might be possible?
- What future work could extend this dataset?

---

### 7. SOURCE CODE AND SCRIPTS

**Purpose**: Document all code and software used in data collection/processing

**MUST Include**:
1. **Public Repositories**:
   - URLs to all code repositories
   - Commit hashes or version tags used
   - DOIs for permanent archival (recommended)
   
2. **Third-Party Software**:
   - All libraries and dependencies
   - **Version numbers for everything**
   - License information
   
3. **Custom Scripts**:
   - Description of key scripts
   - Purpose of each major code component
   - Programming languages used

**MUST NOT Include**:
- Dataset DOI/PIDs/links (those go elsewhere)

**Writing Strategy**:
1. **Examine Codebase**:
   - Check requirements.txt, package.json, or dependency files
   - Review README for software requirements
   - Look at import statements in code
   - Check for docker files or environment specifications
   
2. **Document Everything**:
   - List programming language and version
   - List every library with version number
   - Provide repository URLs
   - Note any commercial software used
   
3. **Structure**:
   - Paragraph 1: Overview of code repositories
   - Table: Key scripts and their purposes
   - Paragraph 2: Programming languages and versions
   - Table: All third-party libraries with versions
   - Paragraph 3: Links to repositories (with DOIs if available)

**Key Questions**:
- Where is the source code hosted?
- What programming languages were used?
- What libraries/frameworks were used? (with versions)
- What commercial software was needed?
- Are there DOIs for code repositories?
- What license is the code under?

**Code Analysis Focus**:
- Dependency files (requirements.txt, package.json, etc.)
- README files
- Import statements
- Version control tags
- Documentation files

---

### 8. ACKNOWLEDGEMENTS AND INTERESTS

**Purpose**: Acknowledge support and declare conflicts of interest

**MUST Include**:
1. Funding sources with grant numbers
2. Institutional support
3. Individual contributions
4. Conflict of interest statement (even if none exist)

**Writing Strategy**:
- Check README for funding information
- Review LICENSE and CONTRIBUTORS files
- Standard format: "This work was supported by..."
- Always include: "The authors declare no conflicts of interest."

---

### 9. REFERENCES

**Purpose**: Provide complete citations in IEEE format

**MUST Include**:
1. All works cited in Background section
2. Citations for methods and algorithms used
3. Citations for all libraries and tools
4. Citations for hardware/sensors/equipment
5. Citations for related datasets
6. URLs for code repositories and software

**Requirements**:
- **Minimum 10 references**
- IEEE format with numbered citations [1], [2], etc.
- Follow IEEE Reference Guide strictly
- References are NOT optional

**Writing Strategy**:
1. **Collect from Codebase**:
   - Check README for citations
   - Look for CITATION.cff or similar files
   - Review documentation for referenced papers
   
2. **Required Citations**:
   - Academic papers for algorithms used
   - Documentation for major libraries
   - Manufacturer specs for hardware
   - Related datasets and benchmarks
   - Previous uses of this data
   
3. **IEEE Format**:
   - [1] A. Author, "Title," Journal, vol. X, no. Y, pp. ZZ-ZZ, Month Year.
   - [2] B. Author, Book Title. City: Publisher, Year.
   - [3] C. Author. (Year, Month Day). Title. [Online]. Available: URL

---

## AI Assistant Workflow for Section Writing

### Step 1: Preparation
1. Read the entire codebase structure
2. Identify main data collection/processing scripts
3. Review README and documentation files
4. Examine data directory structure
5. Check for existing papers or documentation

### Step 2: Section-by-Section Writing
For each section:
1. Review the specific section requirements above
2. Search codebase for relevant information
3. Extract key details from code and documentation
4. Draft section following structure guidelines
5. Ensure all MUST requirements are met
6. Add appropriate citations

### Step 3: Quality Checks
- Verify all sections are present in correct order
- Ensure no section numbering is used
- Check that all "MUST Include" items are present
- Verify minimum 10 references
- Ensure all version numbers are provided
- Confirm figures/tables are included where required

---

## Code Analysis Checklist

When analyzing the codebase to write each section, examine:

### For Collection Methods:
- [ ] Main collection scripts
- [ ] API calls and data sources
- [ ] Configuration files
- [ ] Sampling/polling logic
- [ ] Data ingestion pipelines

### For Validation:
- [ ] Test files and validation scripts
- [ ] Quality metrics calculations
- [ ] Error handling code
- [ ] Statistical analysis functions
- [ ] Data cleaning procedures

### For Records and Storage:
- [ ] Data model definitions
- [ ] Schema files
- [ ] File I/O operations
- [ ] Database configurations
- [ ] Data export functions

### For Source Code:
- [ ] requirements.txt / package.json / etc.
- [ ] Import statements throughout code
- [ ] README installation instructions
- [ ] Docker/environment files
- [ ] LICENSE and version tags

---

## Common Pitfalls to Avoid

1. **DO NOT** include section numbers
2. **DO NOT** add "paper organization" paragraph in Background
3. **DO NOT** put dataset links in Source Code section
4. **DO NOT** forget version numbers for software
5. **DO NOT** skip figures/tables in Validation section
6. **DO NOT** have fewer than 10 references
7. **DO NOT** forget to describe file relationships in Records section
8. **DO NOT** make assumptions - always verify from codebase

---

## Output Format

When writing sections, use:
- Clear markdown formatting
- IEEE-style citations [1], [2], etc.
- Professional academic tone
- Precise technical language
- Active voice where appropriate
- Tables in markdown format
- Figure placeholders with detailed captions

---

## Example Prompts for AI Assistant

**Starting the paper**:
```
Using the IEEE Data Descriptor instructions, write the Background section for this project.
Analyze the codebase to understand the data collected and its value.
```

**For specific sections**:
```
Write the Collection Methods and Design section. Examine the data collection scripts
and create a workflow diagram description.
```

```
Write the Validation and Quality section. Analyze any validation code and create
tables showing data quality metrics.
```

**For completeness check**:
```
Review all sections and ensure: (1) All required elements are present, (2) At least
10 references are included, (3) All version numbers are specified, (4) Required
figures/tables are present.
```

---

## Template Structure

```markdown
# [Dataset Name]: A [Brief Description]

## Abstract
[150-250 words summarizing the dataset, its value, and applications]

## Background
[Context, comparison to other datasets, value proposition, previous uses]

## Collection Methods and Design
[Hardware setup, data collection procedures, processing pipeline]
[Include: Figure 1 - System architecture diagram]
[Include: Figure 2 - Data collection workflow]

## Validation and Quality
[Quality metrics, accuracy measures, validation procedures]
[Include: Table I - Summary statistics]
[Include: Figure 3 - Data quality visualizations]

## Records and Storage
[File structure, data schema, relationships]
[Include: Table II - File listing with details]
[Include: Table III - Data schema description]

## Insights and Notes
[Caveats, limitations, alternative applications]

## Source Code and Scripts
[Code repositories, programming languages, libraries with versions]
[Include: Table IV - Software dependencies and versions]

## Acknowledgements and Interests
[Funding, support, conflict of interest statement]

## References
[Minimum 10 references in IEEE format]
[1] ...
[2] ...
...
```

---

## Final Reminders

- **Always ground content in actual codebase analysis**
- **Never fabricate version numbers or citations**
- **Verify all technical details from code**
- **Maintain IEEE format standards throughout**
- **Ensure reproducibility through detailed descriptions**
- **Be precise with technical terminology**

---

## Document Version
Version 1.0 - IEEE Data Descriptor Writing Instructions for Cursor AI Assistant

