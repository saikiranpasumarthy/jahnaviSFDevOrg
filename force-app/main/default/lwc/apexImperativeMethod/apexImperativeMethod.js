import getContactList from '@salesforce/apex/ContactController.getContactList';
import { LightningElement } from 'lwc';

export default class ApexImperativeMethod extends LightningElement {
    contacts;
    error;
    async handleLoad(){

        try{
            this.contacts=await getContactList();
            this.error=undefined;
        }catch(error){
            this.contacts=undefined;
            this.error=error;
        }
    }
}