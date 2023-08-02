const moongoose = require('mongoose');


const NoteSchema = moongoose.Schema({
    note: {
      type: String,
      required: true,
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
    updatedAt: {
        type: Date,
        default: Date.now,
    }
  });
const Note = moongoose.model("Note", NoteSchema);
module.exports = Note;