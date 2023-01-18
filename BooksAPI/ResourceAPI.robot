*** Settings ***
Documentation    Documentação da API: https://fakerestapi.azurewebsites.net/index.html
Library          RequestsLibrary
Library          Collections

*** Variables ***
${URL_API}        https://fakerestapi.azurewebsites.net/api/
&{BOOKS_15}        ID=15
...               Title=Book 15
...               PageCount=1500

*** Keywords ***
###SETUP E TEARDOWNS###
Conectar a minha API
    Create Session    fakeAPI    ${URL_API}

###Ações
Requisitar todos os livros
    ${RESPOSTA}        GET On Session    fakeAPI     Books
    Log                           ${RESPOSTA.text}
    Set Test Variable     ${RESPOSTA} 

Requisitar o livro "${ID_LIVRO}"
    ${RESPOSTA}        GET On Session    fakeAPI     Books/${ID_LIVRO}
    Log                           ${RESPOSTA.text}
    Set Test Variable     ${RESPOSTA} 
    
### Conferências
Conferir o status code    
    [Arguments]                   ${STATUSCODE_DESEJADO}
    Should Be Equal As Strings    ${RESPOSTA.status_code}    ${STATUSCODE_DESEJADO}

Conferir o reason
    [Arguments]                    ${REASON_DESEJADO}
    Should Be Equal As Strings     ${RESPOSTA.reason}        ${REASON_DESEJADO}  


Conferir se retorna uma lista com "${QTDE_LIVROS}" livros
    Length Should Be                ${RESPOSTA.json()}           ${QTDE_LIVROS}           

Conferir se retorna todos os dados corretos do livro 15      
    Dictionary Should Contain Item    ${RESPOSTA.json()}    ID               ${BOOKS_15.ID}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    Title=Book 15    ${BOOKS_15.Title}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    PageCount        ${BOOKS_15.PageCount}
    Should Not Be Empty               ${RESPOSTA.json()["Description"]}
    Should Not Be Empty               ${RESPOSTA.json()["Excerpt"]} 
    Should Not Be Empty               ${RESPOSTA.json()["PublishDate"]}        

