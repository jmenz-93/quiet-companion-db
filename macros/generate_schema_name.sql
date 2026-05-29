{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- if custom_schema_name is none -%}
        -- No custom schema provided, use the default from profiles.yml
        {{ target.schema }}
    {%- else -%}
        -- Custom schema provided, use EXACTLY the custom schema name
        {{ custom_schema_name | trim }}
    {%- endif -%}

{%- endmacro %}