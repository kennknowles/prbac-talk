% Parameterized Role-Based Access Control
% Kenneth Knowles
% September 24, 2013

Access Control
--------------

Can Kenn read `secrets.txt`?

Can ***person*** do ***action***? (on ***object***)


Formal Statements
-----------------

HasPermission("read", "Kenn", "secrets.txt")

`Permission(name="read", params={"user": "kenn", "file": "secrets.txt"})`


Unix Permissions
----------------

1. Users may be members of groups.
2. Files have owners and groups.
3. Files have read, write, execute bits for their owner, group, and everyone else

Directories and other stuff sort of shoehorned in.


Unix Permissions Proof
----------------------

```
$ ls -l secrets.txt
-rwxr-----  1 root  wheel   375 Sept 10 17:47 secrets.txt
```

HasPermission("read", "kenn", "secrets.txt") ?

1. "kenn" is in group "wheel"
2. "wheel" owns "secrets.txt"
3. The "group read" bit is true.

Thus Kenn can read it.


Unix Permissions Refutation
---------------------------

```
$ ls -l secrets.txt
-rwxr-----  1 root  wheel   375 Sept 10 17:47 secrets.txt
```

$HasPermission("read", "cory", "secrets.txt")$ ?

1. "cory" is not the owner.
2. "cory" is not in group "wheel".
3. The "all read" bit is false.

Thus Cory cannot read it.


Things such an inference system needs
--------------------------------------

It needs to be fast; these things happen all the time.

It needs to be as easy to refute as to prove.

It needs to be easy to understand!


The Logic of Unix Permissions
-----------------------------

1\. Atomic Permissions

 - OwnerRead(_file_)
 - OwnerWrite(_file_)
 - OwnerExec(_file_)
 - GroupRead(_file_)
 - GroupWrite(_file_)
 - GroupExec(_file_)
 - AllRead(_file_)
 - AllWrite(_file_)
 - AllExec(_file_)

(Deliberately being as verbose as the unix data representation)


The Logic of Unix Permissions
-----------------------------

2\. Ownership Info

 - Owner(_user_, _file_)
 - Group(_group_, _file_)



The Logic of Unix Permissions
-----------------------------

3\. Group Memberships
 
 - Member(_user_, _group_)


The Logic of Unix Permissions
-----------------------------

3\. Deduction Rules

 - Owner(_user_, _file_) $\wedge$ OwnerRead(_file_) $\Rightarrow$ HasPermission("read", _user_, _file_)
 - Member(_user_, _group_) $\wedge$ GroupRead(_file_) $\Rightarrow$ HasPermission("read", _user_, _file_)


The Logic of Unix Permissions
-----------------------------

Things to note:

 - Fixed set of hardcoded permissions.
 - Fixed set of deducation rules.
 - A user is zero ("all"), one ("owner"), or two ("group") degrees removed from a permisssion.

In particular, there is no interesting property of logic
leveraged. The most popular addition is transitivity.


Role-Based Access Control (RBAC)
--------------------------------

1. Users may be members of roles
2. Roles may be contained in other Roles. 
3. Roles may be granted permissions explicitly.


Role-Based Access Control Deduction
-----------------------------------

HasPermission("read", "kenn", "secrets.txt") ?

1. "kenn" is a member of "devops"
2. "devops" is contained in "secret-keepers"
3. "secret-keepers" is granted "read" on "secrets.txt"

Thus Kenn can read it.


Role-Based Access Control Refutation
------------------------------------

HasPermission("read", "cory", "secrets.txt") ?

1. "cory" is a member of some roles ...
2. ... and those roles are member of other roles ...
3. ... but none of them grant access to "secrets.txt"

Thus Cory cannot read it.


RBAC Advantages
---------------

Permissions are abstract names, not tied to objects explicitly.

We can make roles such as "secret-keepers" that express our intent
with respect to permissions.

Separately, we can make roles such as "devops" that express intent
with respect to people.

We can then mix & match these pretty freely.

It is "easy" to query all of a users permissions, which is more or
less impossible in Unix.

It is still "easy" to query all people with a certain permission.


RBAC Disadvantages
------------------

Role relationships have to be denormalized to be fast.

Refutations are still an exhaustive search, but of a bigger thing so
it might be harder to understand.

Administration might also require a more complex UI.


The logic of RBAC 
-----------------

1\. Granting permissions to roles.

 - Grant(_role_, _permission_)


The logic of RBAC
-----------------

2\. Organizing users into roles

 - Member(_user_, _role_)


The logic of RBAC
-----------------

3\. Setting up role containment

 - Contained(_subrole_, _superrole_)


The logic of RBAC
-----------------

4\. Deduction rules

Use an auxilliary HasRole(_user_, _role_)

 - Member(_user_, _role_) $\Rightarrow$ HasRole(_user_, _role_)
 - HasRole(_user_, _subrole_) $\wedge$ Contained(_subrole_, _superrole_) $\Rightarrow$ HasRole(_user_, _role_)
 - HasRole(_user_, _role_) $\wedge$ Grant(_role_, _permission_) $\Rightarrow$ HasPermission(_user_, _permission_)


The logic of RBAC
-----------------

Actually, those all look pretty much the same, so if we blur our eyes...

 - Grant(_user_, _role_)
 - Grant(_role_, _role_)
 - Grant(_role_, _permission_)


The logic of RBAC
-----------------

 - Grant(_subthing_, _superthing_) $\Rightarrow$ HasPermission(_subthing_, _superthing_)
 - HasPermission(_thing1_, _thing2_) $\wedge$ HasPermission(_thing2_, _thing3_) $\Rightarrow$ HasPermission(_thing1_, _thing3_)

It is just transitivity, and it is the transitivity of set containment
or (equivalently) entailment.  Each intermediate Role is just a
selected subset of of the users that have a permission. The
intermediate nodes are administrative _only_ and we can always just
summarize the graph.


The logic of RBAC
-----------------

But if we look at it as entailment, and each role being a predicate then role
containment can be looked at as _custom inference rules_.

 - Contains("devops", "secret-keepers")

becomes

 - Member(_user_, "devops") $\Rightarrow$ Member(_user_, "secret-keepers")

and all the deducations come from Member, Grant, and these user-defined rules.


Parameterized Role-Based Access Control
---------------------------------------

The role "Admin" is not specific enough for Dimagi! Currently we
implicitly combine it with knowledge of what domain they are in, and
use Orgs/Teams to work around the limitation to a single domain.

Instead of "Admin" we need "Admin(_domain_)"


Parameterized Role-Based Access Control
---------------------------------------

Take RBAC and add parameters... 

 - Grant(_role_(_roleparams_), _permission_(_permparams_))
 - Member(_user_, _role_(_roleparams_))
 - Contains(_subrole_(_subroleparams_), _superrole_(_superroleparams_))


Parameterized Role-Based Access Control
---------------------------------------

Now we have things like:

 - Member("kenn", Admin("dimagi"))




