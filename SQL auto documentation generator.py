def document_table(schema_info):
    prompt = f"""
Generate documentation for this SQL table:

{schema_info}
"""
    return prompt

schema = """
Table: metrics
Columns:
- id (int)
- value (float)
- created_at (datetime)
"""

print(document_table(schema))