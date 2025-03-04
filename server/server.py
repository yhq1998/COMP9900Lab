from flask import Flask, jsonify, request, abort
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# In-memory storage
students = [
    {"id": 1, "name": "Alice"},
    {"id": 2, "name": "Bob"},
    {"id": 3, "name": "Charlie"},
    {"id": 4, "name": "David"},
    {"id": 5, "name": "Eve"},
]

groups = [
    {"id": 1, "groupName": "Group 1", "members": [1, 2, 3]},
    {"id": 2, "groupName": "Group 2", "members": [4, 5]},
]

@app.route('/api/groups', methods=['GET'])
def get_groups():
    """
    Route to get all groups
    """
    return jsonify(groups)

@app.route('/api/students', methods=['GET'])
def get_students():
    """
    Route to get all students
    """
    return jsonify(students)

@app.route('/api/groups', methods=['POST'])
def create_group():
    group_data = request.json
    group_name = group_data.get("groupName")
    input_members = group_data.get("members")  # userinput maybe is str, array or single number

    # check input   
    if not group_name or not input_members:
        abort(400, "Missing groupName or members in request body")

    # chenge input formats to array
    try:
        # Handle different input formats（such as "1,2,3" or [1,2,3]）
        if isinstance(input_members, str):
            # if input format is string（such as "1" or "1,2,3"）
            member_ids = [int(x.strip()) for x in input_members.split(",")]
        else:
            # if input format is array（such as [1,2,3]）
            member_ids = [int(x) for x in input_members]
    except (ValueError, TypeError):
        abort(401, "Invalid member IDs format. Expected integers (e.g. 1, [1,2], '1,2')")

    # Input id need to exist.
    existing_ids = {s["id"] for s in students} 
    invalid_ids = [mid for mid in member_ids if mid not in existing_ids]

    if invalid_ids:
        abort(400, f"Invalid student IDs: {invalid_ids}. Valid IDs are: {sorted(existing_ids)}")

    # Creat new group
    new_group_id = max(g["id"] for g in groups) + 1 if groups else 1
    new_group = {
        "id": new_group_id,
        "groupName": group_name,
        "members": member_ids,
    }
    groups.append(new_group)

    # return name
    member_names = [s["name"] for s in students if s["id"] in member_ids]
    response = new_group.copy()
    response["member_names"] = member_names
    
    return jsonify(response), 201



@app.route('/api/groups/<int:group_id>', methods=['DELETE'])
def delete_group(group_id):
    """
    Route to delete a group by ID
    """
    global groups
    groups = [group for group in groups if group["id"] != group_id]
    return '', 204

@app.route('/api/groups/<int:group_id>', methods=['GET'])
def get_group(group_id):
    """
    Route to get a group by ID
    """
    group = next((g for g in groups if g["id"] == group_id), None)
    if not group:
        abort(404, "Group not found")
    
    # Fetch full student details for members
    member_details = [s for s in students if s["id"] in group["members"]]
    return jsonify({"id": group["id"], "groupName": group["groupName"], "members": member_details})

if __name__ == '__main__':
    app.run(port=3902, debug=True)
