exports.MerchantPreview = class MerchantPreview {
  constructor(id, name) {
    this.id = id;
    this.name = name;
  }
};

exports.ItemPreview = class ItemPreview {
  constructor(id, name, price) {
    this.id = id;
    this.name = name;
    this.price = price;
  }
};

exports.Merchant = class Merchant {
  constructor(id, name, description, location) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.location = location;
  }
};

exports.Item = class Item {
  constructor(id, name, description, price) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.price = price;
  }
};
