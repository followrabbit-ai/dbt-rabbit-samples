{% macro get_max_date_cte(relation, date_column, cte_name='max_dt', extra_where=none) %}
{{ cte_name }} as (
    select date(max({{ date_column }})) as max_dt
    from {{ relation }}
    {% if extra_where %}
    where {{ extra_where }}
    {% endif %}
)
{% endmacro %}
