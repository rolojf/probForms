module Main exposing (main)

import Browser
import Css.Global
import Form
import Form.Field as Field
import Form.FieldView as FieldView
import Form.Validation as Validation
import Html exposing (Html)
import Html.Styled as HtmlS exposing (div, text)
import Html.Styled.Attributes as AttrS exposing (css)
import Tailwind.Breakpoints as TWBp
import Tailwind.Theme as Theme
import Tailwind.Utilities as Tw exposing (globalStyles)


type alias Model =
    { formModel : Form.Model
    , submitting : Bool
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { formModel = Form.init
      , submitting = False
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions modelo =
    Sub.none


type Msg
    = FormMsg (Form.Msg Msg)
    | OnSubmitForma (Form.Validated String String)


update : Msg -> Model -> ( Model, Cmd Msg )
update mensaje model =
    case mensaje of
        FormMsg formMsg ->
            let
                ( updatedFormModel, cmd ) =
                    Form.update formMsg model.formModel
            in
            ( { model | formModel = updatedFormModel }, cmd )

        OnSubmitForma resultaLaForma ->
            case resultaLaForma of
                Form.Valid signUpData ->
                    let
                        _ =
                            Debug.log "Valid sendSignUpData" signUpData
                    in
                    ( { model | submitting = True }
                    , Cmd.none
                    )

                Form.Invalid _ xyz ->
                    let
                        _ =
                            Debug.log "Invalid sendSignUpData" xyz
                    in
                    -- validation errors are displayed already so
                    -- we don't need to do anything else here
                    ( model, Cmd.none )


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias MiForma =
    { nombre : String }


formView : Model -> HtmlS.Html Msg
formView model =
    laForma
        |> Form.renderStyledHtml
            { submitting = model.submitting
            , state = model.formModel
            , toMsg = FormMsg
            }
            (Form.options "Forma"
                |> Form.withOnSubmit (\{ parsed } -> OnSubmitForma parsed)
            )
            []



--laForma : Form.StyledHtmlForm String String input Msg


laForma =
    Form.form
        (\nombre ->
            { combine = Validation.succeed (\valorCaptado  -> valorCaptado )
            |> Validation.andMap nombre

            -- Validation error parsed Never Never
            , view =
                \contexto -> verCampo "NOMBRE" nombre contexto

            -- Context error input -> List (Html msg)
            }
        )
        |> Form.field "nombre"
            (Field.text |> Field.required "Requerido")


verCampo :
    String
    -> Validation.Field String String FieldView.Input
    -> Form.Context String input
    -> List (HtmlS.Html msg)
verCampo label queCampo contexto =
    div []
        [ HtmlS.label []
            [ text (label ++ " ")

            -- List (Html.Styled.Attribute msg) -> Form.Validation.Field error parsed Input  -> Html.Styled.Html msg
            , FieldView.inputStyled [] queCampo
            , errorsView contexto queCampo
            ]
        ]
        |> List.singleton


errorsView :
    Form.Context String input
    -> Validation.Field String parsed kind
    -> HtmlS.Html msg
errorsView { submitAttempted, errors } field =
    if submitAttempted || Validation.statusAtLeast Validation.Blurred field then
        -- only show validations when a field has been blurred
        -- (it can be annoying to see errors while you type the initial entry for a field, but we want to see the current
        -- errors once we've left the field, even if we are changing it so we know once it's been fixed or whether a new
        -- error is introduced)
        errors
            |> Form.errorsForField field
            |> List.map
                (\error ->
                    HtmlS.li
                        [ AttrS.style "color" "red" ]
                        [ text error ]
                )
            |> HtmlS.ul []

    else
        HtmlS.ul [] []


view : Model -> Html Msg
view modelo =
    div []
        [ Css.Global.global globalStyles
        , div
            [ css
                [ Tw.m_3
                , Tw.border_2
                , Tw.border_r_2
                , Tw.border_color Theme.red_400
                , Tw.p_1
                ]
            ]
            [ text "This page is just static HTML, rendered by Elm."
            , formView modelo
            ]
        ]
        |> HtmlS.toUnstyled
