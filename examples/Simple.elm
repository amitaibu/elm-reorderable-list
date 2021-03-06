module Simple exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style, type', value)
import Html.Events exposing (onClick)
import Html.App
import Reorderable


main : Program Never
main =
    Html.App.beginnerProgram
        { model = init
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { list : List String
    , reorderableState : Reorderable.State
    }


init : Model
init =
    { list = [ "apples", "pears", "oranges", "lemons", "peaches", "satsumas" ]
    , reorderableState = Reorderable.initialState
    }



-- UPDATE


type Msg
    = ReorderableMsg Reorderable.Msg
    | UpdateList (() -> List String)


update : Msg -> Model -> Model
update msg model =
    case Debug.log "Current Message" msg of
        ReorderableMsg childMsg ->
            let
                newReordableState =
                    Reorderable.update childMsg model.reorderableState
            in
                { model | reorderableState = newReordableState }

        UpdateList newListThunk ->
            { model | list = newListThunk () }



-- VIEW


reorderableConfig : Reorderable.Config String Msg
reorderableConfig =
    Reorderable.simpleConfig
        { toMsg = ReorderableMsg
        , updateList = UpdateList
        }


view : Model -> Html Msg
view { list, reorderableState } =
    Reorderable.ul reorderableConfig reorderableState list
