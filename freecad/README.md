# Freecad

## Mesh (STL, ...) to body

- Part workbench
  - Part / Create shape from mesh with 0.01
  - Part / Create Copy / refine Shape (slow)
  - Save !!!
  - Part / Create a Copy / Create simple Copy
  -


## creating another instance

### Copy&Paste and Duplicate

Totally independent

- To create a completely independent copy of a sketch in FreeCAD that is detached from the original, you have two main options:
  Copy and Paste:
  Select the sketch you want to copy
  Press Ctrl+C or use Edit -> Copy
  Press Ctrl+V or use Edit -> Paste
  The new sketch will be created outside the original body
  Drag the new sketch into the desired body if needed
  Duplicate Object:
  Select the sketch you want to copy
  Use Edit -> Duplicate selected objects
  This creates a new sketch inside the same body as the original
  Both methods will create an independent copy that can be modified without affecting the original sketch. The duplicate object method is generally preferred as it creates the copy within the same body, which is often more convenient for further modeling11.
  After creating the copy, you can:
  Move it to a different location
  Attach it to a different plane or face
  Modify its geometry independently
  Remember that these copies will not update if you change the original sketch, allowing you to make independent edits as needed

### Clone

The cloned sketch maintains a "connection" to the original, meaning any changes made to the original sketch will be reflected in the clone
Cloning is different from linking in that cloned sketches can be moved freely, while linked objects follow the movements of their source5.

### Link

Like Clone but linked objects follow the movements of their source


ETX
