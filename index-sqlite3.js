const Database = require("better-sqlite3");

// step-1: Open or create a sqlite database file
const db = new Database("database.sqlite3");

// step-2: Create a table if it doest exists with exec method
db.exec(`
    CREATE TABLE IF NOT EXISTS users(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    email TEXT 
    )
`);

// step-3: Enter or compose the data in arrays of an array
const sampleUsers = [
  ["Shista Chakma", "shistachakma@email.com"],
  ["Anil Ranjan Chakma", "anilranjanchakma@email.com"],
  ["Joyeta Ranjan Chakma", "joyetaranjanchakma@email.com"],
  ["Purba Ranjan Chakma", "purbaranjanchakma@email.com"],
  ["Mintuni Ranjan Chakma", "mintuniranjanchakma@email.com"],
];

const count = db.prepare(`SELECT COUNT(*) AS count FROM users`).get().count;

// step-4: Insert the data composed in step-3 by giving a condition if count is 0.
// We use prepare method for the code insertion security.
if (count == 0) {
  const insert = db.prepare(`insert into users (name, email) values (?, ?)`);
  for (const user of sampleUsers) {
    insert.run(user[0], user[1]);
  }
}

// step-5: Read and print all users inserted.
const users = db.prepare(`select * from users`).all();
console.log("users: ");
users.forEach((user) => {
  console.log(`${user.id}. ${user.name} (${user.email})`);
});

// step-6: Selecting a data to update.
const id = 8;
const name = "Bharali Ranjan Chakma";
const email = "bharaliranjanchakma@email.com";

const update = db
  .prepare(`update users set name = ?, email = ? where id = ? `)
  .run(name, email, id);

const userss = db.prepare(`select * from users`).all();
console.log("Userss: ");
userss.forEach((user) => {
  console.log(`${user.id}. ${user.name} (${user.email})`);
});
