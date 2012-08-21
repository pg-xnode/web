CREATE OR REPLACE FUNCTION menu(root_dynamic varchar) RETURNS xml.node AS $$
	WITH menu_items(item) AS (
		SELECT xml.node(t.data, '{context, uri, label}', ROW(root_dynamic, m.request_uri, m.item_name))
		FROM menu m, template t
		WHERE t.name='menu_item'
		ORDER BY pos
	),
	menu_content(cnt) AS (
		SELECT xml.fragment(item) 
		FROM menu_items
	)
	SELECT xml.node(t.data, '{content}', ROW(cnt)) 
	FROM menu_content mc, template t
	WHERE t.name='menu';
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION page(path_info varchar) RETURNS xml.doc AS $$
	SELECT xml.node(t.data, '{root_static, menu, body}',  ROW(a.root_static, menu(a.root_dynamic), f.data))::xml.doc
	FROM template t, fragment f, application a
	WHERE t.name='page_main' and f.name IN (
		SELECT
			CASE
				WHEN path_info='/' THEN 'body_main'
				WHEN path_info='/doc' THEN 'body_doc'
				WHEN path_info='/download' THEN 'body_download'
				ELSE NULL
			END
		);
$$ LANGUAGE SQL;
