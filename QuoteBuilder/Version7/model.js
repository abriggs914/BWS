
class Model {

    constructor(modelNameIn) {
        this.modelName = modelNameIn;
        this.optionsList = [];
        this.baseSpecs = [];
    }

    clearAllOptions() {
        this.optionsList = [];
    }

    clearAllBaseSpecs() {
        this.optionsList = [];
    }

    toString() {
        return this.modelName; // + ", options [" + this.optionsList + "]";
    }
}