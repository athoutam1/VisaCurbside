exports.StorePreview = class StorePreview {
  constructor(merchantID, merchantName, storeID, storeName) {
    this.merchantID = merchantID;
    this.merchantName = merchantName;
    this.storeID = storeID;
    this.storeName = storeName;
  }
};

exports.Store = class Store {
  constructor(
    merchantID,
    merchantName,
    storeID,
    storeName,
    description,
    location
  ) {
    this.merchantID = merchantID;
    this.merchantName = merchantName;
    this.storeID = storeID;
    this.storeName = storeName;
    this.description = description;
    this.location = location;
  }
};

exports.ItemPreview = class ItemPreview {
  constructor(id, name, price, imageURL) {
    this.id = id;
    this.name = name;
    this.price = price;
    this.imageURL = imageURL;
  }
};

exports.Item = class Item {
  constructor(id, name, price, imageURL, description) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.price = price;
    this.imageURL = imageURL;
  }
};
