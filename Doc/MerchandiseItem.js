{
    supplier : {
        id : int,
        name : "string"
    },
    
    itemName : "string",
    styleNumber : "string",
    brandName : "string",       // Or designerName
    
    // We may also consider passing ID's
    itemCategory : "string",
    itemSubcategory : "string",
    
    fitDescription : "string",
    materialsDescription : "string",
    itemLongDescription : "string",
    unitPrice : decimal,
    
    sizes : [{
                sizeName : "string",
                sizeQuantity : int
             },
             {
                sizeName : "string",
                sizeQuantity : int
             }],
    
    images : [{
              imageURL : "string",
              imageIndex : int
    }]
    
}