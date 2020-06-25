exports.Order = class Order {
  constructor(id, merchantID, itemIDs, shopperID) {
    this.id = id;
    this.merchantID = merchantID;
    this.itemIDs = itemIDs;
    this.shopperID = shopperID;
  }
};
