const mongo = require("mongodb").MongoClient;

class Database {
  constructor(path) {
    this.path = path;
    this.db = null;
    this.client = null;
    this.collections = {
      users: null,
      data: null
    };
    this.mongo = mongo;
  }

  insert(items, type) {
    return new Promise((resolve, reject) => {
      const coll =
        type == "user" ? this.collections.users : this.collections.data;

      if (Array.isArray(items)) {
        coll.insertMany(items, (err, result) => {
          if (err) reject(err);

          resolve(result);
        });
      } else {
        coll.insertOne(items, (err, result) => {
          if (err) reject(err);

          resolve(result);
        });
      }
    });
  }

  find(item, type) {
    const coll =
      type == "user" ? this.collections.users : this.collections.data;

    // find in table according to type using item.id

    if (type == "user") {
      return new Promise((resolve, reject) => {
        coll.find({ id: item.id }).toArray((err, items) => {
          if (err) reject(err);
          resolve(items);
        });
      });
    } else {
      return new Promise((resolve, reject) => {
        coll.find({ userId: item.id }).toArray((err, items) => {
          if (err) reject(err);
          resolve(items);
        });
      });
    }
  }

  update(item, newItem, type) {
    const coll =
      type == "user" ? this.collections.users : this.collections.data;

    return new Promise((resolve, reject) => {
      coll.updateOne({ id: item.id }, { $set: newItem }, (err, item) => {
        if (err) reject(err);
        resolve(item);
      });
    });
  }

  removeProp(item, propToRemove, searchCondition, type) {
    const coll =
      type == "user" ? this.collections.users : this.collections.data;

    return new Promise((resolve, reject) => {
      coll.update(
        { [searchCondition]: item[searchCondition] },
        { $unset: propToRemove },
        (err, item) => {
          if (err) reject(err);
          resolve(item);
        }
      );
    });
  }

  delete(item, type) {
    const coll =
      type == "user" ? this.collections.users : this.collections.data;

    return new Promise((resolve, reject) => {
      coll.delete({ id: item.id }, (err, item) => {
        if (err) reject(err);
        resolve(item);
      });
    });
  }

  connect(db) {
    this.mongo.connect(
      this.path,
      {
        useNewUrlParser: true,
        useUnifiedTopology: true
      },
      (err, client) => {
        if (err) {
          console.log(err);
          return err;
        }

        this.client = client;
        this.db = client.db(db);

        this.collections.users = this.db.collection("ma_users");
        this.collections.data = this.db.collection("ma_data");
      }
    );
  }

  disconnect() {
    this.client.close();
  }

  empty(type) {
    const coll =
      type == "user" ? this.collections.users : this.collections.data;

    return new Promise((resolve, reject) => {
      coll.drop((err, res) => {
        if (err) reject(err);
        this.disconnect();
        if (res) resolve(true);
      });
    });
  }

  destroy() {
    const collIterator = Object.entries(this.collections);

    for (let [, v] of collIterator) {
      v.drop((e, r) => {
        if (e) throw e;
        else return r;
      });
    }
  }
}

module.exports = Database;
