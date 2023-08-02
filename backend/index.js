const express = require("express");
const fs = require("fs");
require("./src/db/notes-db");
const Note = require("./src/models/notes-model");
const env = require("dotenv").config();

const app = express();


app.use(express.json());

// Get all notes
app.get("/notes", async (req, res) => {
  try {
    const notes = await Note.find({});
    res.send(notes);
  } catch (error) {
    res.status(500).send(error);
  }
});

// Add a new note
app.post("/notes", async (req, res) => {
  const note = new Note(req.body);
  try {
    await note.save();
    res.status(201).send(note);
  } catch (error) {
    res.status(500).send(error);
  }
});

// delete the note
app.delete("/notes/:id", async (req, res) => {
  const id = req.params.id;

  try {
    const note = await Note.findByIdAndDelete(id);
    if (!note) {
      return res.status(404).send("Note not found");
    }
    res.send("Note deleted successfully");
  } catch (error) {
    res.status(500).send(error);
  }
});

// patch to update the note
app.patch("/notes/:id", async (req, res) => {
  const id = req.params.id;

  try {
    const note = await Note.findById(id);
    note.note = req.body.note;
    if (!note) {
      return res.status(404).send("Note not found");
    }
    await note.save();
    res.status(200).send(note);
  } catch (error) {
    res.status(404).send(error);
  }
});

app.listen(3000, "192.168.1.6",  () => {
  console.log("Server is up on port 3000");
});
