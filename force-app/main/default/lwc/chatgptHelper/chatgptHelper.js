import { LightningElement, wire, api, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { getRecord, getFieldValue, getObjectInfo } from 'lightning/uiRecordApi';

import getPrompts from '@salesforce/apex/ChatGPTIntegration.getPrompts';
import getPromptsByObj from '@salesforce/apex/ChatGPTIntegration.getPromptsByObj';
import generateChatResponse from '@salesforce/apex/ChatGPTIntegration.generateChatResponse';
import getSummaryLead from '@salesforce/apex/ChatGPTIntegration.getSummaryLead';
import getSummaryOpp from '@salesforce/apex/ChatGPTIntegration.getSummaryOpp';
import getSummaryCon from '@salesforce/apex/ChatGPTIntegration.getSummaryCon';

import OPP_NAME_FIELD from "@salesforce/schema/Opportunity.Name";
import LEAD_NAME_FIELD from "@salesforce/schema/Lead.Name";
import CON_NAME_FIELD from "@salesforce/schema/Contact.Name";

const fieldsOpp = [OPP_NAME_FIELD];
const fieldsLead = [LEAD_NAME_FIELD];
const fieldsCon = [CON_NAME_FIELD];

export default class ChatgptHelper extends LightningElement {
    conversation = [];
    options = [
        { label: 'Lead', value: 'Lead' },
        { label: 'Contact', value: 'Contact' },
        { label: 'Opportunity', value: 'Opportunity' }
    ];
    userChatMessage = '';
    userMessage = '';
    isLoading = false;
    disableInput = false;


    @api recordId;
    @api selectedObject = 'Select Object'; // El valor seleccionado en el select


    @track error;
    @track arrPromptsLead = [];
    @track arrPromptsCon = [];
    @track arrPromptsOpp = [];


    @wire(getPrompts) prompts;
    @wire(getPromptsByObj)
    wiredPrompts({ data, error }) {
        if (data) {
            console.log(data);
            this.arrPromptsLead = data.filter(prompt => prompt.Object__c === 'Lead');
            this.arrPromptsCon = data.filter(prompt => prompt.Object__c === 'Contact');
            this.arrPromptsOpp = data.filter(prompt => prompt.Object__c === 'Opportunity');
        } else if (error) {
            console.error('Error al obtener los datos:', error);
        }
    };

    /* @wire(getPrompts)
    wiredPrompts({ data, error }) {
        console.log(data);
        if (data) {
            // Extrae los valores únicos del campo Picklist "Object__c" de los registros
            const objectValues = Array.from(
                new Set(data.map(prompt => prompt.Object__c))
            );

            // Crea un array de objetos de opciones para el lightning-select
            this.options = objectValues.map(objectValue => ({
                label: objectValue,
                value: objectValue
            }));
        } else if (error) {
            console.error('Error al obtener los datos:', error);
        }
    } */

    /* @wire(getPicklistValues)
    wiredPicklistValues({ error, data }) {
        if (data) {
            // Mapea los valores del campo Object__c a las opciones del select
            this.options = data.map(value => ({
                label: value,
                value: value
            }));
        } else if (error) {
            console.error('Error al obtener los valores del picklist:', error);
        }
    } */

    @wire(CurrentPageReference) pageRef;
    @wire(getRecord, { recordId: "$recordId", fields: fieldsOpp })
    opportunity;
    @wire(getRecord, { recordId: "$recordId", fields: fieldsLead })
    lead;
    @wire(getRecord, { recordId: "$recordId", fields: fieldsCon })
    contact;
    @wire(getRecord) getPromptsByObj;

    get currentObject() {
        return this.pageRef ? JSON.stringify(this.pageRef) : '';
    }

    get oppName() {
        if (this.pageRef.attributes.objectApiName === 'Opportunity') {
            return getFieldValue(this.lead.data, OPP_NAME_FIELD);
        }
        if (this.pageRef.attributes.objectApiName === 'Lead') {
            return getFieldValue(this.lead.data, LEAD_NAME_FIELD);
        }
        if (this.pageRef.attributes.objectApiName === 'Contact') {
            return getFieldValue(this.contact.data, CON_NAME_FIELD);
        }

        return '';
    }

    get messageClass() {
        return this.message.sender === 'user' ? 'user-message' : 'bot-message';
    }

    handleMessageChange(event) {
        this.userMessage = event.target.value;
    }

    callGenerateChatResponse() {
        this.userChatMessage = this.userMessage;
        const newMessage = { id: Date.now(), sender: 'user', content: this.userChatMessage };
        this.conversation.push(newMessage);
        this.isLoading = true;
        this.disableInput = true;
        generateChatResponse({ userMessage: this.userMessage })
            .then(result => {
                const botMessage = { id: Date.now(), sender: 'bot', content: result };
                this.conversation.push(botMessage);
                console.log('then ' + this.conversation);
                this.userMessage = '';
            })
            .catch(error => {
                console.error('Error en la llamada a ChatGPT:', error);
            })
            .finally(() => {
                this.isLoading = false;
                this.userMessage = '';
                this.disableInput = false;
            });
    }

    callPredefinedPrompt(e) {
        let prompt = e.target.dataset.id;
        this.userMessage = prompt;
        this.userChatMessage = prompt;

        const newMessage = { id: Date.now(), sender: 'user', content: this.userChatMessage };
        this.conversation.push(newMessage);
        this.isLoading = true;
        this.disableInput = true;

        if (prompt != 'Dame un resumen del record.') {
            generateChatResponse({ userMessage: prompt })
                .then(result => {
                    const botMessage = { id: Date.now(), sender: 'bot', content: result };
                    this.conversation.push(botMessage);
                })
                .catch(error => {
                    console.error('Error en la llamada a ChatGPT:', error);
                })
                .finally(() => {
                    this.isLoading = false; // Oculta el spinner después de que se complete la carga
                    this.userMessage = '';
                    this.disableInput = false;
                });
        }else if (this.pageRef.attributes.objectApiName == 'Lead') {
            getSummaryLead({ id: this.pageRef.attributes.recordId })
                .then(result => {
                    console.log(JSON.stringify(result));
                    let promptSummary = `Dame un resumen de este record de salesforce. El objeto es de tipo: ${this.pageRef.attributes.objectApiName}. Sus atributos del objeto son: ${JSON.stringify(result)}. No me menciones el atributo. Sino el valor que tiene el Atributo. Ademas que sea un parrafo entendible para el lector.`
                    let resultString = promptSummary.replace(/"/g, '\\"');
                    generateChatResponse({ userMessage: resultString })
                        .then(result => {
                            const botMessage = { id: Date.now(), sender: 'bot', content: result };
                            this.conversation.push(botMessage);
                        })
                        .catch(error => {
                            console.error('Error en la llamada a ChatGPT:', error);
                        })
                        .finally(() => {
                            this.isLoading = false;
                            this.userMessage = '';
                            this.disableInput = false;
                        });
                })
                .catch(error => {
                    console.error('Error en la llamada a getSummaryLead:', error);
                });            
        }else if (this.pageRef.attributes.objectApiName == 'Opportunity') {
            getSummaryOpp({ id: this.pageRef.attributes.recordId })
                .then(result => {
                    console.log(JSON.stringify(result));
                    let promptSummary = `Dame un resumen de este record de salesforce. El objeto es de tipo: ${this.pageRef.attributes.objectApiName}. Sus atributos del objeto son: ${JSON.stringify(result)}. No me menciones el atributo. Sino el valor que tiene el Atributo. Ademas que sea un parrafo entendible para el lector. Cabo mencionar que el 'Amount' es en base a Dolares.`
                    let resultString = promptSummary.replace(/"/g, '\\"');
                    generateChatResponse({ userMessage: resultString })
                        .then(result => {
                            const botMessage = { id: Date.now(), sender: 'bot', content: result };
                            this.conversation.push(botMessage);
                        })
                        .catch(error => {
                            console.error('Error en la llamada a ChatGPT:', error);
                        })
                        .finally(() => {
                            this.isLoading = false;
                            this.userMessage = '';
                            this.disableInput = false;
                        });
                })
                .catch(error => {
                    console.error('Error en la llamada a getSummaryLead:', error);
                });
        }else if (this.pageRef.attributes.objectApiName == 'Contact') {
            getSummaryCon({ id: this.pageRef.attributes.recordId })
                .then(result => {
                    console.log(JSON.stringify(result));
                    let promptSummary = `Dame un resumen de este record de salesforce. El objeto es de tipo: ${this.pageRef.attributes.objectApiName}. Sus atributos del objeto son: ${JSON.stringify(result)}. No me menciones el atributo. Sino el valor que tiene el Atributo. Ademas que sea un parrafo entendible para el lector.`
                    let resultString = promptSummary.replace(/"/g, '\\"');
                    generateChatResponse({ userMessage: resultString })
                        .then(result => {
                            const botMessage = { id: Date.now(), sender: 'bot', content: result };
                            this.conversation.push(botMessage);
                        })
                        .catch(error => {
                            console.error('Error en la llamada a ChatGPT:', error);
                        })
                        .finally(() => {
                            this.isLoading = false;
                            this.userMessage = '';
                            this.disableInput = false;
                        });
                })
                .catch(error => {
                    console.error('Error en la llamada a getSummaryLead:', error);
                });;
        }
    }


    get isLeadPrompt() {
        return this.selectedObject === 'Lead'
    }
    get isContactPrompt() {
        return this.selectedObject === 'Contact'
    }
    get isOpportunityPrompt() {
        return this.selectedObject === 'Opportunity'
    }

    get listPromptsLead() {
        return this.pageRef.attributes.objectApiName === 'Lead';
    }
    get listPromptsCon() {
        return this.pageRef.attributes.objectApiName === 'Contact';
    }
    get listPromptsOpp() {
        return this.pageRef.attributes.objectApiName === 'Opportunity';
    }

    handleChange(event) {
        this.selectedObject = event.detail.value;
    }
}