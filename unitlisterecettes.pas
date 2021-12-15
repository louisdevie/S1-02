unit unitListeRecettes;

interface

    type
        EnumBonus = (AUCUN, FORCE, REGENERATION, CRITIQUE);

        TypeRecette = record
            nom: String;
            effet: EnumBonus;
        end;

    const TAILLE_PAGE_RECETTES = 13;


    procedure initRecettes;

    procedure recettesChargees;


    procedure insererRecette(recette: TypeRecette);


    procedure effacerRecettes;


    procedure triAlphaRecettes;

    procedure triBonusRecettes;

    procedure premierePageRecettes;

    procedure pageSuivanteRecettes;

    procedure pagePrecedenteRecettes;

    function pageCouranteRecettes: Integer;

    function taillePageRecettes: Integer;


    function lireRecette(numero: Integer): TypeRecette;


implementation

    type
        _PtrCelluleRecette = ^_CelluleRecette;

        _CelluleRecette = record
            valeur: TypeRecette;
            precedantOrdreAlpha,
            suivantOrdreAlpha,
            precedantOrdreBonus,
            suivantOrdreBonus: _PtrCelluleRecette;
        end;

        _ModeTri = (ALPHABETIQUE, PARBONUS);

    var
        _premiereRecetteAlpha,
        _premiereRecetteBonus,
        _curseurPage,
        _curseurRecette: _PtrCelluleRecette;
        _pageCourante: Integer;
        _modeTriUtilise: _ModeTri;
        _dernierePage : Integer;   
        _tailleDernierePage : Integer;
        _nombreDeRecettes : Integer;

    procedure initRecettes;
    begin
        _premiereRecetteAlpha := NIL;   
        _premiereRecetteBonus := NIL;
        _curseurPage := NIL;
        _curseurRecette := NIL;
        _nombreDeRecettes := 0;
        _dernierePage := 0;
        _tailleDernierePage := 0;
    end;


    function taillePageRecettes: Integer;
    begin
        if _pageCourante = _dernierePage then
            taillePageRecettes := _tailleDernierePage
        else
            taillePageRecettes := TAILLE_PAGE_RECETTES;
    end;

    // str1 > str2
    function _estApresOrdreAlpha(str1, str2: String): boolean;
    var
        i, tailleMin: Integer;
    begin
        i := 1;
        if length(str1) > length(str2) then
            tailleMin := length(str2)
        else
            tailleMin := length(str1);

        while true do
            if i > tailleMin then begin
                _estApresOrdreAlpha := length(str1) > length(str2);
                break;
            end else if str1[i] = str2[i] then
                i += 1
            else begin
                _estApresOrdreAlpha := ord(str1[i]) > ord(str2[i]);
                break;
            end;
    end;

    // eff1 > eff2
    function _estApresOrdreBonus(eff1, eff2: EnumBonus): boolean;
    begin
        _estApresOrdreBonus := ord(eff1) > ord(eff2);
    end;

    procedure _insererEntreAlpha(nouvelElement, elementAvant, elementApres: _PtrCelluleRecette);
    begin                                                   
        nouvelElement^.precedantOrdreAlpha := elementAvant;
        nouvelElement^.suivantOrdreAlpha := elementApres;      
        elementAvant^.suivantOrdreAlpha := nouvelElement;
        elementApres^.precedantOrdreAlpha := nouvelElement;
    end;

    procedure _insererEntreBonus(nouvelElement, elementAvant, elementApres: _PtrCelluleRecette);
    begin
        nouvelElement^.precedantOrdreBonus := elementAvant;
        nouvelElement^.suivantOrdreBonus := elementApres;
        elementAvant^.suivantOrdreBonus := nouvelElement;
        elementApres^.precedantOrdreBonus := nouvelElement;
    end;

    procedure insererRecette(recette: TypeRecette);
    var
        curseurAlpha, curseurBonus, nouvelleRecette: _PtrCelluleRecette;
    begin
        _nombreDeRecettes += 1;

        if _premiereRecetteAlpha = NIL then begin
            new(_premiereRecetteAlpha);
            _premiereRecetteBonus := _premiereRecetteAlpha;

            _premiereRecetteAlpha^.valeur := recette;
            _premiereRecetteAlpha^.precedantOrdreAlpha := _premiereRecetteAlpha;
            _premiereRecetteAlpha^.suivantOrdreAlpha := _premiereRecetteAlpha;
            _premiereRecetteAlpha^.precedantOrdreBonus := _premiereRecetteBonus;
            _premiereRecetteAlpha^.suivantOrdreBonus := _premiereRecetteBonus;

        end else begin
            new(nouvelleRecette);
            nouvelleRecette^.valeur := recette;

            if not _estApresOrdreAlpha(recette.nom, _premiereRecetteAlpha^.valeur.nom) then begin
                _insererEntreAlpha(nouvelleRecette, _premiereRecetteAlpha^.precedantOrdreAlpha, _premiereRecetteAlpha);
                _premiereRecetteAlpha := nouvelleRecette;

            end else begin
                curseurAlpha := _premiereRecetteAlpha;
                while curseurAlpha <> NIL do begin
                    curseurAlpha := curseurAlpha^.precedantOrdreAlpha;
                    if _estApresOrdreAlpha(recette.nom, curseurAlpha^.valeur.nom) then begin
                        _insererEntreAlpha(nouvelleRecette, curseurAlpha, curseurAlpha^.suivantOrdreAlpha);
                        curseurAlpha := NIL;
                    end;
                end;
            end;
               
            if not _estApresOrdreBonus(recette.effet, _premiereRecetteBonus^.valeur.effet) then begin
                _insererEntreBonus(nouvelleRecette, _premiereRecetteBonus^.precedantOrdreBonus, _premiereRecetteBonus);
                _premiereRecetteBonus := nouvelleRecette;

            end else begin
                curseurBonus := _premiereRecetteBonus;
                while curseurBonus <> NIL do begin
                    curseurBonus := curseurBonus^.precedantOrdreBonus;
                    if _estApresOrdreBonus(recette.effet, curseurBonus^.valeur.effet) then begin
                        _insererEntreBonus(nouvelleRecette, curseurBonus, curseurBonus^.suivantOrdreBonus);
                        curseurBonus := NIL;
                    end;
                end;
            end;
        end;
    end;


    procedure recettesChargees;
    begin
        _dernierePage := _nombreDeRecettes div TAILLE_PAGE_RECETTES;
        _tailleDernierePage := _nombreDeRecettes mod TAILLE_PAGE_RECETTES;
        if _tailleDernierePage = 0 then
            _tailleDernierePage := TAILLE_PAGE_RECETTES
        else
            _dernierePage += 1;
    end;

    procedure effacerRecettes;
    var
        curseur, precedent: _PtrCelluleRecette;
    begin
        // si la liste est déja vide, ne rien faire
        if _premiereRecetteAlpha <> NIL then begin
            // on parcours la liste en utilisant l'ordre alphabétique
            // "casser la boucle" en détachant le premier élément du dernier
            (_premiereRecetteAlpha^.precedantOrdreAlpha)^.suivantOrdreAlpha := NIL;

            curseur := _premiereRecetteAlpha;

            while curseur <> NIL do begin
                precedent := curseur;
                curseur := precedent^.suivantOrdreAlpha;
                dispose(precedent);
            end;

            initRecettes;
        end;
    end;


    procedure triAlphaRecettes;
    begin
        _modeTriUtilise := ALPHABETIQUE;
    end;

    procedure triBonusRecettes;
    begin
        _modeTriUtilise := PARBONUS;
    end;

    procedure premierePageRecettes;
    begin
        case _modeTriUtilise of
             ALPHABETIQUE: begin
                 _curseurPage := _premiereRecetteAlpha;
                 _pageCourante := 1;
             end;
             PARBONUS: begin
                 _curseurPage := _premiereRecetteBonus;
                 _pageCourante := 1;
             end;
        end;
    end;

    procedure pageSuivanteRecettes;
    var
        i: Integer;
    begin
        case _modeTriUtilise of
             ALPHABETIQUE: begin
                 for i := 1 to taillePageRecettes do
                     _curseurPage := _curseurPage^.suivantOrdreAlpha;
                 if _pageCourante = _dernierePage then
                     _pageCourante := 1
                 else
                     _pageCourante += 1;
             end;
             PARBONUS: begin
                 for i := 1 to taillePageRecettes do
                     _curseurPage := _curseurPage^.suivantOrdreBonus;
                 if _pageCourante = _dernierePage then
                     _pageCourante := 1
                 else
                     _pageCourante += 1;
             end;
        end;
    end;

    procedure pagePrecedenteRecettes;
    var
        i: Integer;
    begin
        case _modeTriUtilise of
             ALPHABETIQUE: begin
                 for i := 0 to taillePageRecettes do
                     _curseurPage := _curseurPage^.precedantOrdreAlpha;
                 if _pageCourante = 1 then
                     _pageCourante := _dernierePage
                 else
                     _pageCourante -= 1;
             end;
             PARBONUS: begin
                 for i := 0 to taillePageRecettes do
                     _curseurPage := _curseurPage^.precedantOrdreBonus;
                 if _pageCourante = 1 then
                     _pageCourante := _dernierePage
                 else
                     _pageCourante -= 1;
             end;
        end;
    end;

    function pageCouranteRecettes: Integer;
    begin
        pageCouranteRecettes := _pageCourante;
    end;


    function lireRecette(numero: Integer): TypeRecette;
    var
        i: Integer;
    begin
        _curseurRecette := _curseurPage;
        case _modeTriUtilise of
             ALPHABETIQUE: begin
                 for i := 1 to numero do
                     _curseurRecette := _curseurRecette^.suivantOrdreAlpha;
                 lireRecette := _curseurRecette^.valeur;
             end;
             PARBONUS: begin
                 for i := 1 to numero do
                     _curseurRecette := _curseurRecette^.suivantOrdreBonus;
                 lireRecette := _curseurRecette^.valeur;
             end;
        end;
    end;

end.

