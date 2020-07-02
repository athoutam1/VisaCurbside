exports.StorePreview = class StorePreview {
  constructor(merchantID, merchantName, storeID, storeName, location) {
    this.merchantID = merchantID;
    this.merchantName = merchantName;
    this.storeID = storeID;
    this.storeName = storeName;
    this.location = location;
  }
};

exports.Store = class Store {
  constructor(
    merchantID,
    merchantName,
    storeID,
    storeName,
    description,
    location,
    imageURL,
    logoURL
  ) {
    this.merchantID = merchantID;
    this.merchantName = merchantName;
    this.storeID = storeID;
    this.storeName = storeName;
    this.description = description;
    this.location = location;
    this.imageURL = imageURL;
    this.logoURL = logoURL;
  }
};

exports.ItemPreview = class ItemPreview {
  constructor(id, name, price, description, imageURL) {
    this.id = id;
    this.name = name;
    this.price = price;
    this.description = description;
    this.imageURL = imageURL;
    this.logoURL
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
