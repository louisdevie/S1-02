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
            precedantOrdreAlpha: _PtrCelluleRecette;
            suivantOrdreAlpha: _PtrCelluleRecette;
            precedantOrdreBonus: _PtrCelluleRecette;
            suivantOrdreBonus: _PtrCelluleRecette;
        end;

    var
        _pointeurPremierePage: _PtrCelluleRecette;
        _pointeurPage: _PtrCelluleRecette;
        _pointeurRecette: _PtrCelluleRecette;
        _pageCourante: Integer;

    procedure initRecettes;
    begin
        _pointeurPremierePage := NIL;  
        _pointeurPage := NIL;
        _pointeurRecette := NIL;
    end;


    procedure insererRecette(recette: TypeRecette);
    begin

    end;


    procedure effacerRecettes;
    begin
        // À FAIRE
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

