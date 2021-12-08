unit unitListeRecettes;

interface

    type
        EnumBonus = (AUCUN, REGENERATION, CRITIQUE, FORCE);

        TypeRecette = record
            nom: string;
            effet: EnumBonus;
        end;

    const TAILLE_PAGE_RECETTES = 10;


    procedure initRecettes;


    procedure insererRecette(recette: TypeRecette);


    procedure effacerRecettes;

    procedure premierePageRecettes;

    procedure pageSuivanteRecettes;

    procedure pagePrecedenteRecettes;

    function pageCouranteRecettes: Integer;


    function lireRecette: TypeRecette;


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

    var
        _premiereRecetteAlpha,
        _premiereRecetteBonus,
        _curseurPage,
        _curseurRecette: _PtrCelluleRecette;
        _pageCourante: Integer;

    procedure initRecettes;
    begin
        _premiereRecetteAlpha := NIL;   
        _premiereRecetteBonus := NIL;
        _cusrseurPage := NIL;
        _curseurRecette := NIL;
    end;


    procedure insererRecette(recette: TypeRecette);
    var
        curseurAlpha, curseurBonus: _PtrCelluleRecette;
    begin
        // À FAIRE
    end;


    procedure effacerRecettes;
    var
        curseur, precedent: _PtrCelluleRecette;
    begin
        curseur := _premiereRecetteAlpha;
        while curseur <> NIL do begin
            precedent := curseur;
            cuseur := precedent^.suivantOrdreAlpha;
            dispose(precedent);
        end;
    end;

    procedure premierePageRecettes;
    begin
        // À FAIRE
    end;

    procedure pageSuivanteRecettes;
    begin
        // À FAIRE
    end;

    procedure pagePrecedenteRecettes;
    begin
        // À FAIRE
    end;

    function pageCouranteRecettes: Integer;
    begin
        // À FAIRE
    end;


    function lireRecette: TypeRecette;
    begin
        // À FAIRE
    end;

end.

