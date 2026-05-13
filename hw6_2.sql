FROM GEMINI
```
SELECT p.Name
FROM Bird_nests bn
JOIN Site s ON bn.Site = s.Code
JOIN Personnel p ON bn.Observer = p.Abbreviation
WHERE LOWER(s.Site_name) = 'nome'
  AND bn.Year BETWEEN 1998 AND 2008
  AND bn.ageMethod = 'float'
GROUP BY p.Abbreviation, p.Name
HAVING COUNT(bn.Nest_ID) = 36;
```
In this query- 

---
FROM ChatGPT
```
SELECT p.Name
FROM Bird_nests bn
JOIN Personnel p
    ON bn.Observer = p.Abbreviation
WHERE bn.Site = 'nome'
  AND bn.Year BETWEEN 1998 AND 2008
  AND bn.ageMethod = 'float'
GROUP BY p.Abbreviation, p.Name
HAVING COUNT(*) = 36;
```

FROM Claude
```
SELECT p.Name, COUNT(*) AS Num_floated_nests
FROM Bird_nests bn
JOIN Personnel p ON bn.Observer = p.Abbreviation
JOIN Site s ON bn.Site = s.Code
WHERE s.Site_name ILIKE '%nome%'
  AND bn.Year BETWEEN 1998 AND 2008
  AND bn.ageMethod = 'float'
GROUP BY p.Abbreviation, p.Name
HAVING COUNT(*) = 36;
```


