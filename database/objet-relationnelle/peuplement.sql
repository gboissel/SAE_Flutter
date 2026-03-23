
DELETE FROM vols;


INSERT INTO vols VALUES (
    'AF100', 'CDG', TO_DATE('2026-03-10 08:00', 'YYYY-MM-DD HH24:MI'),
    'LHR', TO_DATE('2026-03-10 10:00', 'YYYY-MM-DD HH24:MI'),
    equipage_tab(
        membre_t('Dupont', 'Pilote'),
        membre_t('Durand', 'Co-pilote')
    ),
    indices_tab(
        indice_t('carbone', 2, 5),
        indice_t('confort', 4, 4)
    )
);


INSERT INTO vols VALUES (
    'AZ500', 'ORY', TO_DATE('2026-03-10 09:30', 'YYYY-MM-DD HH24:MI'),
    'FCO', TO_DATE('2026-03-10 11:30', 'YYYY-MM-DD HH24:MI'),
    equipage_tab(
        membre_t('Rossi', 'Pilote'),
        membre_t('Bianchi', 'Steward')
    ),
    indices_tab(
        indice_t('prix', 1, 3),
        indice_t('ponctualite', 5, 5)
    )
);


INSERT INTO vols VALUES (
    'BA200', 'LHR', TO_DATE('2026-03-10 14:00', 'YYYY-MM-DD HH24:MI'),
    'JFK', TO_DATE('2026-03-10 22:00', 'YYYY-MM-DD HH24:MI'),
    equipage_tab(
        membre_t('Smith', 'Pilote'),
        membre_t('Jones', 'Hôtesse')
    ),
    indices_tab(
        indice_t('securite', 5, 4),
        indice_t('repas', 3, 2)
    )
);


INSERT INTO vols VALUES (
    'EK400', 'CDG', TO_DATE('2026-03-10 20:00', 'YYYY-MM-DD HH24:MI'),
    'DXB', TO_DATE('2026-03-11 05:00', 'YYYY-MM-DD HH24:MI'),
    equipage_tab(
        membre_t('Al Maktoum', 'Pilote'),
        membre_t('Zayed', 'Commissaire')
    ),
    indices_tab(
        indice_t('luxe', 2, 3),
        indice_t('divertissement', 5, 5)
    )
);

COMMIT;